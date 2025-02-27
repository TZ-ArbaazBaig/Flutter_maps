import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
// import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MapWithPhoneRotation(),
  ));
}

class MapWithPhoneRotation extends StatefulWidget {
  const MapWithPhoneRotation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapWithPhoneRotationState createState() => _MapWithPhoneRotationState();
}

class _MapWithPhoneRotationState extends State<MapWithPhoneRotation> {
  GoogleMapController? _mapController;
  CameraPosition? initialCameraPosition;
  BitmapDescriptor? _carIcon;
  double _currentRotation = 0.0;
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  final LatLng _defaultDestination =
      const LatLng(12.939411, 80.157898); // Default destination

  Set<Marker> markers = {};
  final Set<Circle> _circles = {};
  Set<Polyline> polylines = {};
  // double _distanceTravelled = 0.0;
  Position? _previousPosition;
  double? totalDistance;
  final List<LatLng> _polylineCoordinates = [];
  bool hasReachedDestination = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();

    // _listenToSensorData();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.requestPermission();
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
//snap to road for car icon for road display
        LatLng userPosition = LatLng(position.latitude, position.longitude);

        // Snap the position to the nearest road
        LatLng snappedPosition = await _snapToRoad(userPosition);

        _currentPosition = snappedPosition;

        markers.clear();
        markers.add(Marker(
          markerId: const MarkerId('carMarker'),
          position: snappedPosition, //change
          rotation: _currentRotation, // Rotation based on sensor data
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

        if (_previousPosition != null) {
          double distance = Geolocator.distanceBetween(
            _previousPosition!.latitude,
            _previousPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          // _distanceTravelled += distance;
        }

        _previousPosition = position;
        await _getDirections();
        if (!hasReachedDestination) {
          _checkIfReachedDestination();
        }

        setState(() {});
      }
    });
    //  _listenToSensorData();
  }

  void _checkIfReachedDestination() {
    double distanceToDestination = Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      _defaultDestination.latitude,
      _defaultDestination.longitude,
    );

    if (distanceToDestination <= 10) {
      // Show dialog and prevent further popups
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

        if (points.isNotEmpty) {
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
      } else {
        debugPrint('Directions API Error: ${data['status']}');
      }
    } else {
      debugPrint('HTTP Error: ${response.statusCode}');
    }
  }


  void _updateMarkerRotation() {
    // Calculate the bearing towards the destination
    double bearing = _calculateBearing(_currentPosition, _defaultDestination);

    setState(() {
      _currentRotation = bearing;
      markers = markers.map((marker) {
        if (marker.markerId.value == "carMarker") {
          return marker.copyWith(rotationParam: _currentRotation);
        }
        return marker;
      }).toSet();
    });
  }

  // double _calculateOrientation(
  //     AccelerometerEvent accelerometer, MagnetometerEvent magnetometer) {
  //   // Normalize accelerometer data
  //   double ax = accelerometer.x;
  //   double ay = accelerometer.y;
  //   double az = accelerometer.z;

  //   double normAccel = sqrt(ax * ax + ay * ay + az * az);
  //   ax /= normAccel;
  //   ay /= normAccel;
  //   az /= normAccel;

  //   // Normalize magnetometer data
  //   double mx = magnetometer.x;
  //   double my = magnetometer.y;
  //   double mz = magnetometer.z;

  //   double normMag = sqrt(mx * mx + my * my + mz * mz);
  //   mx /= normMag;
  //   my /= normMag;
  //   mz /= normMag;

  //   // Compute horizontal components
  //   double hx = my * az - mz * ay;
  //   double hy = mz * ax - mx * az;

  //   // Calculate heading (rotation in degrees)
  //   double heading = atan2(hy, hx) * (180 / pi);

  //   // Normalize heading to range [0, 360]
  //   return (heading + 360) % 360;
  // }

  //added
  Future<LatLng> _snapToRoad(LatLng position) async {
    const String apiKey = "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs";
    final String url =
        "https://roads.googleapis.com/v1/snapToRoads?path=${position.latitude},${position.longitude}&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['snappedPoints'] != null && data['snappedPoints'].isNotEmpty) {
        final snappedLocation = data['snappedPoints'][0]['location'];
        return LatLng(
            snappedLocation['latitude'], snappedLocation['longitude']);
      }
    }
    debugPrint("Failed to snap to road: ${response.statusCode}");
    return position; // Return original position if snapping fails
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lon2 = end.longitude * pi / 180;

    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double initialBearing = atan2(y, x);
    double compassBearing = (initialBearing * 180 / pi + 360) % 360;

    return compassBearing;
  }

  double _calculateDistance(LatLng start, LatLng end) {
    double distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
    return distanceInMeters;
  }


  @override
  Widget build(BuildContext context) {
    totalDistance =
        _calculateDistance(_currentPosition, _defaultDestination) / 1000;
    return Scaffold(
      appBar: AppBar(title: const Text("Live Tracking")),
      body:
          _currentPosition.latitude == 0.0 && _currentPosition.longitude == 0.0
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition,
                        zoom: 14,
                      ),
                      markers: markers,
                      polylines: polylines,
                      circles: _circles,
                      onMapCreated: (controller) => _mapController = controller,
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () {
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(_currentPosition, 20),
          );
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (totalDistance != null)
              Text(
                'Total Distance: ${totalDistance!.toStringAsFixed(2)} km',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
