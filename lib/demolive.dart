// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'dart:math' as math;
// import 'google_maps_services.dart'; // Assuming you have Google Maps service to fetch the route

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LiveTrackingMap(),
//     );
//   }
// }

// class LiveTrackingMap extends StatefulWidget {
//   @override
//   _LiveTrackingMapState createState() => _LiveTrackingMapState();
// }

// class _LiveTrackingMapState extends State<LiveTrackingMap> {
//   GoogleMapController? _mapController;
//   LatLng _currentPosition = const LatLng(0, 0);
//   LatLng _destination = const LatLng(13.061774, 80.268296); 
//   Marker? _carMarker;
//   Set<Polyline> _polylines = {};
//   List<LatLng> _polylineCoordinates = [];
//   Timer? _timer;
//   BitmapDescriptor? _carIcon;
//   final GoogleMapsServices _googleMapsServices = GoogleMapsServices();

//   @override
//   void initState() {
//     super.initState();
//     _setCustomMarker();
//     _getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _setCustomMarker() async {
//     _carIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(48, 48)),
//       'assets/images/carMarker.png', // Add a custom car marker image to your assets folder
//     );
//   }

//   void _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//     });

//     _drawRoute();
//   }

//   void _drawRoute() async {
//     // Get route coordinates from Google Maps API
//     String encodedPolyline = await _googleMapsServices.getRouteCoordinates(
//       _currentPosition,
//       _destination,
//     );

//     _polylineCoordinates = _decodePolyline(encodedPolyline);
//     _addPolyline();
//     _startCarSimulation();
//   }

//   List<LatLng> _decodePolyline(String polyline) {
//     List points = _decodePoly(polyline);
//     List<LatLng> result = [];
//     for (int i = 0; i < points.length; i += 2) {
//       result.add(LatLng(points[i], points[i + 1]));
//     }
//     return result;
//   }

//   List _decodePoly(String poly) {
//     List<int> list = poly.codeUnits;
//     List<double> result = [];
//     int index = 0;
//     int len = poly.length;
//     int c = 0;

//     do {
//       int shift = 0;
//       int res = 0;
//       do {
//         c = list[index] - 63;
//         res |= (c & 0x1F) << (shift * 5);
//         index++;
//         shift++;
//       } while (c >= 32);

//       if (res & 1 == 1) {
//         res = ~res;
//       }
//       result.add((res >> 1) * 0.00001);
//     } while (index < len);

//     for (int i = 2; i < result.length; i++) result[i] += result[i - 2];
//     return result;
//   }

//   void _addPolyline() {
//     setState(() {
//       _polylines.add(Polyline(
//         polylineId: const PolylineId("route"),
//         color: Colors.blue,
//         width: 5,
//         points: _polylineCoordinates,
//       ));
//     });
//   }

//   void _startCarSimulation() {
//     int index = 0;

//     // Timer that simulates the car moving along the route
//     _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       if (index < _polylineCoordinates.length - 1) {
//         LatLng prevPosition = _polylineCoordinates[index];
//         LatLng newPosition = _polylineCoordinates[index + 1];
//         index++;

//         // Pass both previous and current positions to _moveCar
//         _moveCar(newPosition, prevPosition);
//       } else {
//         timer.cancel(); // Stop the timer once the car reaches the destination
//       }
//     });
//   }

//   void _moveCar(LatLng newPosition, LatLng prevPosition) {
//     // Calculate the rotation from the previous to the new position
//     double rotation = _calculateRotation(prevPosition, newPosition);

//     setState(() {
//       _carMarker = Marker(
//         markerId: const MarkerId('car'),
//         position: newPosition,
//         icon: _carIcon ?? BitmapDescriptor.defaultMarker,
//         rotation: rotation,  // Apply the rotation based on the polyline direction
//         anchor: const Offset(0.5, 0.5), // Center the marker anchor to avoid flip
//       );

//       _currentPosition = newPosition;
//     });
//   }

//   double _calculateRotation(LatLng start, LatLng end) {
//     // Calculate the angle based on the change in latitude and longitude
//     double deltaLongitude = end.longitude - start.longitude;
//     double deltaLatitude = end.latitude - start.latitude;

//     double angle = math.atan2(deltaLatitude, deltaLongitude);
//     return angle * 180 / math.pi; // Convert to degrees
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Live Car Tracking'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: _currentPosition.latitude == 0 && _currentPosition.longitude == 0
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _currentPosition,
//                 zoom: 15,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController = controller;
//               },
//               markers: {
//                 if (_carMarker != null) _carMarker!,
//                 Marker(
//                   markerId: const MarkerId('destination'),
//                   position: _destination,
//                   infoWindow: const InfoWindow(title: 'Destination'),
//                 ),
//               },
//               polylines: _polylines,
//               myLocationEnabled: true,
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiveTrackingMap(),
    );
  }
}

class LiveTrackingMap extends StatefulWidget {
  const LiveTrackingMap({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LiveTrackingMapState createState() => _LiveTrackingMapState();
}

class _LiveTrackingMapState extends State<LiveTrackingMap> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  final LatLng _destination = const LatLng(13.061774, 80.268296); 
  Marker? _carMarker;
  final Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  Timer? _timer;
  BitmapDescriptor? _carIcon;
  final String _googleApiKey = 'AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs'; 
  @override
  void initState() {
    super.initState();
    _setCustomMarker();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Set custom car marker icon
  void _setCustomMarker() async {
    _carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/carMarker.png', 
    );
  }

  // Start real-time location updates
  void _startLocationUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _getCurrentLocation();
    });
  }
 double? t_distance;
  // Get the current location of the user and snap it to the nearest road
  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Snap the location to the nearest road
    LatLng snappedLocation = await _snapToRoad(LatLng(position.latitude, position.longitude));

    setState(() {
      _currentPosition = snappedLocation;
      // Update the marker position and route if location is fetched
      _moveCar(_currentPosition);
      _drawRoute();
      _calculateDistanceToDestination();
    });
  }
  
void _calculateDistanceToDestination() async {
  try {
    double distance = await getDistanceBetweenLocations(
      _currentPosition,
      _destination,
      _googleApiKey,
    );

    print("Distance to destination: ${distance.toStringAsFixed(2)} km");
    t_distance=distance;
    // Optionally, update the UI with the distance
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Distance to destination: ${distance.toStringAsFixed(2)} km')),
    // );
  } catch (e) {
    print("Error calculating distance: $e");
  }
}

  // Snaps the given coordinates to the nearest road using Google Roads API
  Future<LatLng> _snapToRoad(LatLng location) async {
    final url = Uri.parse(
      'https://roads.googleapis.com/v1/snapToRoads?path=${location.latitude},${location.longitude}&key=$_googleApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['snappedPoints'] != null && data['snappedPoints'].isNotEmpty) {
        var snappedPoint = data['snappedPoints'][0];
        return LatLng(snappedPoint['location']['latitude'], snappedPoint['location']['longitude']);
      } else {
        return location; // If no snapped point found, return the original location
      }
    } else {
      throw Exception('Failed to get snapped road');
    }
  }

  // Draw the route based on the Directions API polyline
  void _drawRoute() async {
    String encodedPolyline = await _getRouteCoordinates(
      _currentPosition,
      _destination,
    );

    if (encodedPolyline.isNotEmpty) {
      _polylineCoordinates = _decodePolyline(encodedPolyline);
      _updatePolyline();  // Update polyline to the new route
    }
  }

  // Decode the polyline from the Directions API
  List<LatLng> _decodePolyline(String polyline) {
    List points = _decodePoly(polyline);
    List<LatLng> result = [];
    for (int i = 0; i < points.length; i += 2) {
      result.add(LatLng(points[i], points[i + 1]));
    }
    return result;
  }

  // Decode the polyline string into a list of points
  List _decodePoly(String poly) {
    List<int> list = poly.codeUnits;
    List<double> result = [];
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      int shift = 0;
      int res = 0;
      do {
        c = list[index] - 63;
        res |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (res & 1 == 1) {
        res = ~res;
      }
      result.add((res >> 1) * 0.00001);
    } while (index < len);

    for (int i = 2; i < result.length; i++) {
      result[i] += result[i - 2];
    }
    return result;
  }

  // Update the polyline after the car moves
  void _updatePolyline() {
    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: _polylineCoordinates,
      ));
    });
  }

  // Move the car to a new position and adjust the rotation
  void _moveCar(LatLng newPosition) {
    double rotation = _calculateRotation(
      _carMarker?.position ?? _currentPosition,
      newPosition,
      
     
    );
    _mapController?.animateCamera(
  CameraUpdate.newLatLng(newPosition),
);


    setState(() {
      _carMarker = Marker(
        markerId: const MarkerId('car'),
        position: newPosition,
        icon: _carIcon ?? BitmapDescriptor.defaultMarker,
        rotation: rotation,  // Apply the rotation based on the polyline direction
        anchor: const Offset(0.5, 0.5), // Center the marker anchor to avoid flip
      );
    });
  }

  // Calculate the rotation of the car based on the direction of movement
  double _calculateRotation(LatLng start, LatLng end) {
    double deltaLongitude = end.longitude - start.longitude;
    double deltaLatitude = end.latitude - start.latitude;
    double angle = math.atan2(deltaLatitude, deltaLongitude);
    return angle * 180 / math.pi; // Convert to degrees
  }

  Future<double> getDistanceBetweenLocations(
    LatLng origin, LatLng destination, String apiKey) async {
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/distancematrix/json'
    '?origins=${origin.latitude},${origin.longitude}'
    '&destinations=${destination.latitude},${destination.longitude}'
    '&key=$apiKey',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['rows'] != null &&
        data['rows'][0]['elements'][0]['status'] == 'OK') {
      final distanceInMeters =
          data['rows'][0]['elements'][0]['distance']['value'];
      // Convert meters to kilometers
      return distanceInMeters / 1000;
    } else {
      throw Exception('Error: ${data['rows'][0]['elements'][0]['status']}');
    }
  } else {
    throw Exception('Failed to fetch distance. Status code: ${response.statusCode}');
  }
}


  Future<String> _getRouteCoordinates(LatLng origin, LatLng destination) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_googleApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var routes = data['routes'];
      if (routes.isNotEmpty) {
        var route = routes[0];
        var polyline = route['overview_polyline']['points'];
        return polyline;
      } else {
        return '';
      }
    } else {
      throw Exception('Failed to get route');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Car Tracking'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _currentPosition.latitude == 0 && _currentPosition.longitude == 0
          ? const Center(child: CircularProgressIndicator())
          : Stack(
            children: [GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15,
                ),
                  compassEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                markers: {
                  if (_carMarker != null) _carMarker!,
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: _destination,
                    infoWindow: const InfoWindow(title: 'Destination'),
                  ),
                },
                polylines: _polylines,
                myLocationEnabled: true,
              ),
              Container(
                child: Text('Distance: $t_distance km',style: TextStyle(fontSize: 20,backgroundColor: Colors.white),),
              )
          ]),
            
    );
  }
}
