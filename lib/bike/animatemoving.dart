import 'dart:async';
import 'dart:convert';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MapWithSnapping(),
  ));
}

class MapWithSnapping extends StatefulWidget {
  const MapWithSnapping({Key? key}) : super(key: key);

  @override
  State<MapWithSnapping> createState() => _MapWithSnappingState();
}

class _MapWithSnappingState extends State<MapWithSnapping> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _carIcon;
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  LatLng _defaultDestination = const LatLng(12.939353, 80.157992);
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> _polylineCoordinates = [];
  Position? _previousPosition;
  bool hasReachedDestination = false;
final Set<Circle> _circles = {};
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _setCarIcon();
    _determinePosition();
  }

  Future<void> _setCarIcon() async {
    _carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/car_icon.png',
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied');
    }
 _carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(28, 28)),
      'assets/images/car_icon1.png',
    );
    Geolocator.getPositionStream().listen((Position? position) async {
      if (position != null) {
        LatLng userPosition = LatLng(position.latitude, position.longitude);
        // Snap to road
        LatLng snappedPosition = await _snapToRoad(userPosition);
markers.clear();
        markers.add(Marker(
          markerId: const MarkerId('carMarker'),
          position: _currentPosition,
          // rotation: _currentRotation, // Rotation based on sensor data
          icon: _carIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ));
        markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: _defaultDestination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Default Destination'),
        ));

        _circles.clear();
        _circles.add(Circle(
          circleId: const CircleId('user_circle'),
          center: _currentPosition,
          radius: 30,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ));


        // Animate car marker
        if (_previousPosition != null) {
          await _animateCarMarker(
            LatLng(_previousPosition!.latitude, _previousPosition!.longitude),
            snappedPosition,
          );
        }

        _previousPosition = position;
        _currentPosition = snappedPosition;

        await _getDirections();
        if (!hasReachedDestination) {
          _checkIfReachedDestination();
        }
        setState(() {});
      }
    });
  }

  Future<void> _getDirections() async {
    String googleApiKey = "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs";

    final response = await http.get(Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition.latitude},${_currentPosition.longitude}&destination=${_defaultDestination.latitude},${_defaultDestination.longitude}&key=$googleApiKey",
    ));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data['status'] == 'OK') {
        var points = PolylinePoints()
            .decodePolyline(data['routes'][0]['overview_polyline']['points']);

        _polylineCoordinates.clear();
        _polylineCoordinates.addAll(
            points.map((point) => LatLng(point.latitude, point.longitude)));

        polylines.clear();
        polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: _polylineCoordinates,
        ));
      }
    }
  }

  Future<LatLng> _snapToRoad(LatLng position) async {
    String googleApiKey = "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs";

    final response = await http.get(Uri.parse(
      'https://roads.googleapis.com/v1/snapToRoads?path=${position.latitude},${position.longitude}&interpolate=false&key=$googleApiKey',
    ));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var snappedPoint = data['snappedPoints'][0]['location'];
      return LatLng(snappedPoint['latitude'], snappedPoint['longitude']);
    }

    return position; // Return original if snapping fails
  }

  Future<void> _animateCarMarker(LatLng startPosition, LatLng endPosition) async {
    const int animationDuration = 2000; // 5 seconds
    const int frameRate = 60; // Frames per second
    final int totalFrames = (animationDuration / (1000 / frameRate)).round();

    for (int i = 0; i <= totalFrames; i++) {
      double progress = i / totalFrames;
      double lat = startPosition.latitude +
          (endPosition.latitude - startPosition.latitude) * progress;
      double lng = startPosition.longitude +
          (endPosition.longitude - startPosition.longitude) * progress;

      LatLng animatedPosition = LatLng(lat, lng);

      setState(() {
        _currentPosition = animatedPosition;
        markers = markers.map((marker) {
          if (marker.markerId.value == "carMarker") {
            return marker.copyWith(positionParam: _currentPosition);
          }
          return marker;
        }).toSet();
      });

      await Future.delayed(Duration(milliseconds: (1000 / frameRate).round()));
    }
  }

  void _checkIfReachedDestination() {
    double distanceToDestination = Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      _defaultDestination.latitude,
      _defaultDestination.longitude,
    );

    if (distanceToDestination <= 10) {
      _showReachedDestinationDialog();
      hasReachedDestination = true;
    }
  }

  void _showReachedDestinationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have reached your destination!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Tracking")),
      body: _currentPosition.latitude == 0.0 && _currentPosition.longitude == 0.0
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 15,
              ),
              markers: markers,
              circles: _circles,
              polylines: polylines,
              onMapCreated: (controller) => _mapController = controller,
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () {
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(_currentPosition, 20),
          );
        },
      ),
    );
  }
}
