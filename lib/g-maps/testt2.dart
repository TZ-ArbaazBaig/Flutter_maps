// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:currency_converter/g-maps/marker_icon.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MapWithPhoneRotation(),
//   ));
// }

// class MapWithPhoneRotation extends StatefulWidget {
//   @override
//   _MapWithPhoneRotationState createState() => _MapWithPhoneRotationState();
// }

// class _MapWithPhoneRotationState extends State<MapWithPhoneRotation> {
//   late GoogleMapController mapController;
//   // Set<Marker> markers = {};
//   // Set<Polyline> polylines = {};
//   // LatLng _initialPosition = LatLng(0.0, 0.0); // Default position
//   // LatLng _destinationPosition = LatLng(12.939387, 80.157704); // Default destination (Chennai)
//   // List<LatLng> polylineCoordinates = [];

//   CameraPosition? initialCameraPosition;
//   LatLng? originLatLng;
//   LatLng? destinationLatLng = const LatLng(
//       12.939875533183898, 80.15740725183278);
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {}; // Set to store polylines
//   //  double _heading = 0.0;
//   List<LatLng> polylineCoordinates = []; // List for polyline coordinates
//   PolylinePoints polylinePoints = PolylinePoints();
//   double _currentRotation = 0.0;
//   Position? _previousPosition;
//   BitmapDescriptor? liveLocationMarker;

//   StreamSubscription? _sensorSubscription;
//   AccelerometerEvent? _latestAccelerometer;
//   MagnetometerEvent? _latestMagnetometer;
//   BitmapDescriptor? _bikeIcon; // To store the bike icon
//   final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

//   // PolylinePoints polylinePoints = PolylinePoints();

//   @override
//   void initState() {
//     super.initState();
//     // _loadBikeIcon(); // Load the bike icon
//     _getUserLocation();
//      if (destinationLatLng != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('destination'),
//           position: destinationLatLng!,
//           infoWindow: const InfoWindow(title: 'Default Destination'),
//         ),
//       );

//       // Add polyline between origin and destination
//       polylineCoordinates.add(destinationLatLng!);
//   }

//   // Fetch the user's current location and update the map's initial position
//   Future<void> _getUserLocation() async {
//      bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     // Check for permissions
//     permission = await _geolocatorPlatform.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await _geolocatorPlatform.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     // Set location settings based on platform
//     late LocationSettings locationSettings;

//     if (defaultTargetPlatform == TargetPlatform.android) {
//       locationSettings = AndroidSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 4,
//         forceLocationManager: true,
//         intervalDuration: const Duration(seconds: 10),
//         foregroundNotificationConfig: const ForegroundNotificationConfig(
//           notificationText:
//               "This app will continue to receive your location even when you aren't using it",
//           notificationTitle: "Location Tracking",
//           enableWakeLock: true,
//         ),
//       );
//     } else if (defaultTargetPlatform == TargetPlatform.iOS ||
//         defaultTargetPlatform == TargetPlatform.macOS) {
//       locationSettings = AppleSettings(
//         accuracy: LocationAccuracy.high,
//         activityType: ActivityType.fitness,
//         distanceFilter: 4,
//         pauseLocationUpdatesAutomatically: true,
//         showBackgroundLocationIndicator: false,
//       );
//     } else if (kIsWeb) {
//       locationSettings = WebSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//         maximumAge: const Duration(minutes: 5),
//       );
//     } else {
//       locationSettings = const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//       );
//     }

//     await getBytesFromAsset('assets/images/car_icon1.png', 100).then((value) {
//       setState(() {
//         liveLocationMarker = value;
//       });
//     });

//     // Get location updates
//     _geolocatorPlatform
//         .getPositionStream(locationSettings: locationSettings)
//         .listen((Position? position) async {
//       if (position != null) {
//         originLatLng = LatLng(position.latitude, position.longitude);

//         // Set the camera position and update the map
//         initialCameraPosition = CameraPosition(target: originLatLng!, zoom: 15);

 
//         markers.removeWhere(
//             (element) => element.mapsId.value.compareTo("origin") == 0);
//         markers.add(Marker(
//           markerId: const MarkerId('origin'),
//           position: originLatLng!,
//           // rotation: currentLocation.heading,
//           icon: liveLocationMarker!,
//           infoWindow: const InfoWindow(title: 'Current Location'),
//         ));

// // Add or update circle around the user
//         // circles.clear();
//         // circles.add(Circle(
//         //   circleId: const CircleId('user_circle'),
//         //   center: originLatLng!,
//         //   radius: 30, // Circle with 30m radius
//         //   fillColor: Colors.blue.withOpacity(0.2),
//         //   strokeColor: Colors.blue,
//         //   strokeWidth: 1,
//         // ));

//         // Calculate distance between current and previous position
//         if (_previousPosition != null) {
//           double distance = Geolocator.distanceBetween(
//             _previousPosition!.latitude,
//             _previousPosition!.longitude,
//             position.latitude,
//             position.longitude,
//           );

//         //   setState(() {
//         //     _distanceTravelled += distance;
//         //   });
//         // }

//         _previousPosition = position;

//      _startListeningToSensors();
//         // Fetch directions and update polyline
//         await _getRouteToDestination();

//         setState(() {}); // Trigger a rebuild to update UI
//     // _getRouteToDestination(); 
//       }}
//     });
//   }


// // }
// //     });
// //   }
    
//     // Fetch the route after getting the initial position

//   // Load the bike icon asynchronously
//   void _loadBikeIcon() async {
//     _bikeIcon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(size: Size(32, 32)),
//       'assets/images/car_icon1.png', // Use your car icon
//     );
//     setState(() {
//       if (markers != null) {
//         markers = markers!.copyWith(iconParam: _bikeIcon);
//       }
//     });
//   }

//   // Start listening to accelerometer and magnetometer streams
//   void _startListeningToSensors() {
//     _sensorSubscription = accelerometerEvents.listen((accelerometerEvent) {
//       _latestAccelerometer = accelerometerEvent;
//       _updatemarkersRotation();
//     });

//     magnetometerEvents.listen((magnetometerEvent) {
//       _latestMagnetometer = magnetometerEvent;
//       _updatemarkersRotation();
//     });
//   }

//   // Update the markers's rotation based on phone orientation
//   void _updatemarkersRotation() {
//     if (_latestAccelerometer != null && _latestMagnetometer != null) {
//       double newRotation = _calculateOrientation(
//         _latestAccelerometer!,
//         _latestMagnetometer!,
//       );

//       double diff = newRotation - _currentRotation;
//       if (diff.abs() > 0.5) {
//         double interpolationSpeed = 0.1;
//         if (diff > 180) {
//           diff -= 360;
//         } else if (diff < -180) {
//           diff += 360;
//         }

//         double smoothRotation = _currentRotation + diff * interpolationSpeed;

//         setState(() {
//           _currentRotation = smoothRotation;
//           if (markers != null) {
//             markers = markers!.copyWith(rotationParam: _currentRotation);
//           }
//         });
//       }
//     }
//   }

//   // Calculate the phone's orientation in degrees
//   double _calculateOrientation(AccelerometerEvent accelerometer, MagnetometerEvent magnetometer) {
//     double ax = accelerometer.x;
//     double ay = accelerometer.y;
//     double az = accelerometer.z;

//     double normAccel = sqrt(ax * ax + ay * ay + az * az);
//     ax /= normAccel;
//     ay /= normAccel;
//     az /= normAccel;

//     double mx = magnetometer.x;
//     double my = magnetometer.y;
//     double mz = magnetometer.z;

//     double normMag = sqrt(mx * mx + my * my + mz * mz);
//     mx /= normMag;
//     my /= normMag;
//     mz /= normMag;

//     double hx = my * az - mz * ay;
//     double hy = mz * ax - mx * az;

//     double heading = atan2(hy, hx) * (180 / pi);
//     return (heading + 360) % 360;
//   }

//   // Get the route from the user's location to the destination and draw the polyline
//   Future<void> _getRouteToDestination() async {
//    String googleApiKey =
//         "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs"; 

//     if (originLatLng != null && destinationLatLng != null) {
//       final response = await http.get(Uri.parse(
//         "https://maps.googleapis.com/maps/api/directions/json?origin=${originLatLng!.latitude},${originLatLng!.longitude}&destination=${destinationLatLng!.latitude},${destinationLatLng!.longitude}&key=$googleApiKey",
//       ));
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);

//         if (data['status'] == 'OK') {
//           var points = PolylinePoints()
//               .decodePolyline(data['routes'][0]['overview_polyline']['points']);

//           if (points.isNotEmpty) {
//             polylineCoordinates.clear();
//             polylineCoordinates.addAll(
//                 points.map((point) => LatLng(point.latitude, point.longitude)));

//             polylines.add(Polyline(
//               polylineId: const PolylineId('route'),
//               color: Colors.blue,
//               width: 5,
//               points: polylineCoordinates,
//             ));

//             setState(() {});
//           }
//         } else {
//           debugPrint('Directions API Error: ${data['status']}');
//         }
//       } else {
//         debugPrint('HTTP Error: ${response.statusCode}');
//       }
//     }
//   }
//   }

//   @override
//   void dispose() {
//     _sensorSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Live Tracking Map")),
//       body: initialCameraPosition == null
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               // initialCameraPosition: CameraPosition(
//               //   target: initialCameraPosition,
//               //   zoom: 14,
//               // ),
//               // markers: markers != null ? {markers!} : {},

// mapType: MapType.normal,
//               initialCameraPosition: initialCameraPosition!,
//               tiltGesturesEnabled: true,
//               compassEnabled: true,
//               zoomGesturesEnabled: true,
//               markers: markers,
//               polylines: polylines,
//               // circles: circles,
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },

//               // polylines: polylines != null ? {polylines!} : {},
//               // onMapCreated: (controller) => _mapController = controller,
//               // myLocationEnabled: true,
//               // myLocationButtonEnabled: false,
//               // onCameraMove: (position) {
//               //   setState(() {
//               //     _initialPosition = position.target;
//               //   });
//               // },
//             ),
//              floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.my_location_outlined),
//         onPressed: () {
//           if (originLatLng != null) {
//             mapController
//                 ?.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 16));
//           }
//         },
//       ),
//     );
//   }
// }
