import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
void main() => runApp(LiveTrackingApp());

class LiveTrackingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LiveTrackingScreen(),
    );
  }
}

class LiveTrackingScreen extends StatefulWidget {
  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Location _location = Location();
  Marker? userMarker;
  Marker destinationMarker = const Marker(
    markerId: MarkerId('destination'),
    position: LatLng(12.939304, 80.158018), // Example: destination location
    icon: BitmapDescriptor.defaultMarker,
  );
  LatLng currentPosition = const LatLng(0.0, 0.0);
  List<LatLng> polylineCoordinates = [];
  Polyline? routePolyline;
  // String navigationInstruction = "Start navigation";
  double distance = 0.0;
  int estimatedTime = 0;

  BitmapDescriptor? carIcon;

  @override
  void initState() {
    super.initState();
    _setCustomMarker();
    _setupLocationTracking();
  }

  Future<void> _setCustomMarker() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/car_icon1.png',
    );
  }

  Future<void> _setupLocationTracking() async {
    final GoogleMapController controller = await _controller.future;
    _location.onLocationChanged.listen((LocationData loc) async {
      currentPosition = LatLng(loc.latitude!, loc.longitude!);

      if (polylineCoordinates.isEmpty) {
        await _fetchRoutePolyline();
      }

      LatLng nearestPoint = _getNearestPoint(currentPosition);

      setState(() {
        userMarker = Marker(
          markerId: const MarkerId('user'),
          position: nearestPoint,
          icon: carIcon ?? BitmapDescriptor.defaultMarker,
        );

        distance = Geolocator.distanceBetween(
          loc.latitude!,
          loc.longitude!,
          destinationMarker.position.latitude,
          destinationMarker.position.longitude,
        ) /
            1000; // Distance in km

        // Travel time = Distance / Average Speed (40 km/h converted to minutes)
        estimatedTime = ((distance / 40) * 60).round();

        // Update navigation instructions
        if (distance < 0.05) {
          Fluttertoast.showToast(msg: "You have reached your destination!");
          // navigationInstruction = "You have reached your destination!";
        }
        //  else {
        //   navigationInstruction = "On your way!";
        // }
      });
    });
  }

  Future<void> _fetchRoutePolyline() async {
    final apiKey = 'AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs'; // Replace with your actual API key
    final origin = '${currentPosition.latitude},${currentPosition.longitude}';
    final destination = '${destinationMarker.position.latitude},${destinationMarker.position.longitude}';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final steps = data['routes'][0]['legs'][0]['steps'];

      setState(() {
        polylineCoordinates = steps
            .map<LatLng>((step) => LatLng(
                  step['start_location']['lat'] as double,
                  step['start_location']['lng'] as double,
                ))
            .toList();

        // Add the last point of the route
        polylineCoordinates.add(LatLng(
          steps.last['end_location']['lat'] as double,
          steps.last['end_location']['lng'] as double,
        ));

        routePolyline = Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        );
      });
    } else {
      Fluttertoast.showToast(msg: "Failed to load route.");
    }
  }

  LatLng _getNearestPoint(LatLng userLocation) {
    LatLng? nearestPoint;
    double minDistance = double.infinity;

    for (final point in polylineCoordinates) {
      double currentDistance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        point.latitude,
        point.longitude,
      );

      if (currentDistance < minDistance) {
        minDistance = currentDistance;
        nearestPoint = point;
      }
    }

    return nearestPoint ?? userLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking App'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _controller.complete(controller),
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.971598, 77.594566),
              zoom: 14.0,
            ),
            markers: {
              if (userMarker != null) userMarker!,
              destinationMarker,
            },
            polylines: routePolyline != null ? {routePolyline!} : {},
            myLocationEnabled: false, // Disable default blue dot and circle
          ),
               Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Text(
                'Distance: ${distance.toStringAsFixed(2)} km\nEstimated Time: $estimatedTime mins',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
