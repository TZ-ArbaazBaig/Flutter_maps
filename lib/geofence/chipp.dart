// import 'package:flutter/foundation.dart';
// // import 'package:currency_converter/geofence/getPlaces.dart';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: GeofenceDropdown(),
//     );
//   }
// }

// class GeofenceDropdown extends StatefulWidget {
//   const GeofenceDropdown({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _GeofenceDropdownState createState() => _GeofenceDropdownState();
// }

// class _GeofenceDropdownState extends State<GeofenceDropdown> {
//   late GoogleMapController mapController;
//   final LatLng _userLocation = const LatLng(13.064558388716563, 80.26604517544497);
//   Future<List<String>>? _places;
//   final double _radius = 1000; // Radius of geofence in meters
//   final Set<Circle> _circles = {};
//   // late Position _position;

//   @override
//   void initState() {
//     super.initState();
//     _initializeLocation();
//   }

//   // Get the user's current location
//   // Future<Position> _getUserLocation() async {
//   //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   LocationPermission permission = await Geolocator.checkPermission();

//   //   if (!serviceEnabled) {
//   //     throw Exception('Location services are disabled.');
//   //   }

//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.denied) {
//   //       throw Exception('Location permission denied.');
//   //     }
//   //   }

//   //   if (permission == LocationPermission.deniedForever) {
//   //     throw Exception('Location permissions are permanently denied.');
//   //   }

//   //   return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   // }

//   // Fetch nearby places within the geofence using Google Places API
//   Future<List<String>> _fetchNearbyPlaces(LatLng location, double radius) async {
//     const String apiKey = 'AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs'; 
//     final String endpoint =
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.latitude},${location.longitude}&radius=$radius&key=$apiKey';

//     final response = await http.get(Uri.parse(endpoint));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final places = data['results'] as List;

//       List<String> placeNames = places.map((place) => place['name'] as String).toList();
//       return placeNames;
//     } else {
//       throw Exception('Failed to load places');
//     }
//   }

//   // Initialize user's location and update geofence
//   void _initializeLocation() async {
//     try {
//       // _position = await _getUserLocation();
//       setState(() {
//         // _userLocation = LatLng(_position.latitude, _position.longitude);
//         _places = _fetchNearbyPlaces(_userLocation, _radius);
//         _createGeofence();
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error fetching location: $e');
//       }
//     }
//   }

//   // Create a geofence circle
//   void _createGeofence() {
//     _circles.add(
//       Circle(
//         circleId: const CircleId('geofence_circle'),
//         center: _userLocation,
//         radius: _radius,
//         strokeColor: Colors.blue,
//         strokeWidth: 3,
//         fillColor: Colors.blue.withOpacity(0.3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Geofence Nearby Places')),
//       body: Column(
//         children: [
//           // Google Map
//           SizedBox(
//             height: 400,
//             width: double.infinity,
//             child: GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 target: _userLocation,
//                 zoom: 14,
//               ),
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("user_location"),
//                   position: _userLocation,
//                   infoWindow: const InfoWindow(title: "User Location"),
//                   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//                 ),
//               },
//               circles: _circles,
//             ),
//           ),
//           // Dropdown for nearby places
//           Expanded(
//             child: FutureBuilder<List<String>>(
//               future: _places,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No places found'));
//                 } else {
//                   List<String> places = snapshot.data!;
//                   return Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: DropdownButton<String>(
//                       isExpanded: true,
//                       hint: const Text('Select a place'),
//                       items: places.map((place) {
//                         return DropdownMenuItem<String>(
//                           value: place,
//                           child: Text(place),
//                         );
//                       }).toList(),
//                       onChanged: (selectedPlace) {
//                         // Handle the selected place
//                         if (kDebugMode) {
//                           print('Selected place: $selectedPlace');
//                         }
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/places.dart' as googleMapPlace;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Autocomplete',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapAutocompleteScreen(),
    );
  }
}

class MapAutocompleteScreen extends StatefulWidget {
  @override
  _MapAutocompleteScreenState createState() => _MapAutocompleteScreenState();
}

class _MapAutocompleteScreenState extends State<MapAutocompleteScreen> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Default San Francisco
  LatLng? _selectedPosition;

  // final String _apiKey = "YOUR_API_KEY";
  final _placesApiClient = googleMapPlace.GoogleMapsPlaces(apiKey: "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs");

  final TextEditingController _searchController = TextEditingController();
  List<googleMapPlace.Prediction> _autocompleteResults = [];

  void _onSearchChanged(String value) async {
    if (value.isEmpty) {
      setState(() {
        _autocompleteResults = [];
      });
      return;
    }

    final predictions = await _placesApiClient.autocomplete(value);
    setState(() {
      _autocompleteResults = predictions.predictions;
    });
  }

  void _onPlaceSelected(googleMapPlace.Prediction result) async {
    final details = await _placesApiClient.getDetailsByPlaceId(result.placeId!);

    if (details.result.geometry != null) {
      final lat = details.result.geometry!.location.lat;
      final lng = details.result.geometry!.location.lng;

      setState(() {
        _selectedPosition = LatLng(lat, lng);
        _autocompleteResults = [];
        _searchController.text = result.description!;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_selectedPosition!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autocomplete with Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 10),
            markers: _selectedPosition != null
                ? {Marker(markerId: MarkerId("selected"), position: _selectedPosition!)}
                : {},
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search for a place",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                if (_autocompleteResults.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _autocompleteResults.length,
                      itemBuilder: (context, index) {
                        final result = _autocompleteResults[index];
                        return ListTile(
                          title: Text(result.description ?? ""),
                          onTap: () => _onPlaceSelected(result),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
