import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(12.9396667, 80.1572500); // Starting point
  final LatLng _mylocation = const LatLng(13.063894, 80.269287); // Destination point

  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String distance = "0";

  double _radiusInKm = 0;
  String _rangeStatus = "";
  TextEditingController _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();

    markers.add(Marker(
      markerId: const MarkerId("_currentLocation"),
      icon: BitmapDescriptor.defaultMarker,
      position: _initialPosition,
    ));
    markers.add(Marker(
      markerId: const MarkerId("MyLocation"),
      icon: BitmapDescriptor.defaultMarker,
      position: _mylocation,
    ));

    // Load polyline and directions
    _getDirections();
  }

  Future<void> _getDirections() async {
    String googleApiKey = "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs"; 
    final response = await http.get(Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json?origin=${_initialPosition.latitude},${_initialPosition.longitude}&destination=${_mylocation.latitude},${_mylocation.longitude}&key=$googleApiKey",
    ));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data['status'] == 'OK') {
        var route = data['routes'][0];
        var leg = route['legs'][0];
        var polyline = route['overview_polyline']['points'];
        var distanceText = leg['distance']['text'];
        var distanceValue = leg['distance']['value'];

        setState(() {
          distance = distanceText;

          // Decode polyline
          polylineCoordinates = _decodePoly(polyline);
          polylines.clear();
          polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));
        });
      } else {
        print("No route found");
      }
    } else {
      print("Failed to get directions");
    }
  }

  List<LatLng> _decodePoly(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = ((result & 0x01) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = ((result & 0x01) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylineCoordinates;
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

  void _checkGeofence() {
    if (_radiusInKm == 0) {
      setState(() {
        _rangeStatus = "Please set a valid radius.";
        circles.clear();
      });
      return;
    }

    double radiusInMeters = _radiusInKm * 1000;
    double distance = _calculateDistance(_initialPosition, _mylocation);

    setState(() {
      if (distance <= radiusInMeters) {
        _rangeStatus = "In range";
      } else {
        _rangeStatus = "Not in range";
      }
    });
  }

  void _updateGeofence() {
    if (_radiusInKm > 0) {
      setState(() {
        circles.clear();
        circles.add(Circle(
          circleId: const CircleId('geofence'),
          center: _initialPosition,
          radius: _radiusInKm * 1000,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ));
      });
    } else {
      setState(() {
        circles.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance: $distance'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _radiusController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Radius (in kilometers)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _radiusInKm = double.tryParse(value) ?? 0;
                });
                _updateGeofence();
              },
            ),
          ),
          ElevatedButton(
            onPressed: _checkGeofence,
            child: const Text('Check if In Range'),
          ),
          Text(
            _rangeStatus,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14,
              ),
              markers: markers,
              circles: circles,
              polylines: polylines,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
