// import 'dart:convert';
// import 'package:currency_converter/map_model.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;


// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late GoogleMapController _mapController;
//   MapModel? _mapModel;

//   // Polygon set
//   Set<Polygon> polygons = {};

//   // Text Controller for Search
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Default polygons for a place (e.g., Chennai)
//     _fetchPolygonsForPlace("Chennai");
//   }

//   Future<void> _fetchPolygonsForPlace(String place) async {
//     final url = Uri.parse(
//       'https://nominatim.openstreetmap.org/search?q=$place&format=json&polygon_geojson=1',
//     );

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);

//         bool polygonFound = false;

//         for (var item in data) {
//           if (item['importance'] != null) {
//             final mapModel = MapModel.fromjson(item);

//             // Create and add polygon
//             final polygon = Polygon(
//               polygonId: PolygonId('polygon_${place.toLowerCase()}'),
//               points: mapModel.polygon.coords,
//               fillColor: Colors.black.withOpacity(0.2),
//               strokeColor: Colors.red,
//               strokeWidth: 3,
//             );

//             setState(() {
//               _mapModel = mapModel;
//               polygons = {polygon}; // Replace previous polygons
//             });

//             if (mapModel.polygon.coords.isNotEmpty) {
//               _mapController.animateCamera(
//                 CameraUpdate.newLatLng(mapModel.polygon.coords[0]),
//               );
//             }

//             polygonFound = true;
//             break; // Stop after finding the desired polygon
//           }
//         }

//         if (!polygonFound) {
//           _showSnackbar('No polygons found for "$place".');
//         }
//       } else {
//         _showSnackbar('Error fetching data from the server.');
//       }
//     } catch (e) {
//       _showSnackbar('An error occurred while fetching polygons.');
//     }
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Polygon Map',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: "Enter a place (e.g., Chennai)",
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onSubmitted: (value) {
//                 if (value.isNotEmpty) {
//                   _fetchPolygonsForPlace(value);
//                 }
//               },
//             ),
//           ),
//           Expanded(
//             child: GoogleMap(
//               markers: {
//                 Marker(
//                   markerId: const MarkerId('defaultMarker'),
//                   position: const LatLng(9.9614405, 76.2369445),
//                 ),
//               },
//               initialCameraPosition: CameraPosition(
//                 target: _mapModel == null
//                     ? const LatLng(37.7749, -122.4194)
//                     : _mapModel!.polygon.coords.firstOrNull ?? const LatLng(0, 0),
//                 zoom: 14,
//               ),
//               onMapCreated: (controller) => _mapController = controller,
//               polygons: polygons,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension ListFirstOrNull<T> on List<T> {
//   /// Returns the first element of the list or null if the list is empty
//   T? get firstOrNull => isNotEmpty ? this[0] : null;
// }
