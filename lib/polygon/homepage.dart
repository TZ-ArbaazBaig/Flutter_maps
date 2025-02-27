import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late gmaps.GoogleMapController mapController;

  // Polygons and coordinates
  Set<gmaps.Polygon> polygons = {};
  List<gmaps.LatLng> polygonCoords = [];
  String displayName = 'Unknown Location';

  // User input controller
  final TextEditingController _placeController = TextEditingController();

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  /// Fetch data from Nominatim API based on user input
  Future<void> _fetchData(String place) async {
    print('Starting to call the API for: $place');
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$place&format=json&polygon_geojson=1');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> decoded = json.decode(response.body);

      if (decoded.isNotEmpty) {
        // Find the polygon with the highest "importance"
        decoded.sort((a, b) => b['importance'].compareTo(a['importance']));
        Map<String, dynamic> item = decoded.first;

        setState(() {
          displayName = item['display_name'] ?? 'Unknown Location';
          polygonCoords = _parsePolygon(item['geojson']);
        });

        _addPolygonToMap();
      } else {
        print('No data found for the given place.');
      }
    } else {
      print('Error calling the API: ${response.statusCode}');
    }
  }

  /// Parse GeoJSON to extract polygon coordinates
  List<gmaps.LatLng> _parsePolygon(Map<String, dynamic> geoJson) {
    List<gmaps.LatLng> latLngList = [];

    try {
      final List<dynamic>? coordinates = geoJson['coordinates'];
      if (coordinates != null && coordinates.isNotEmpty) {
        for (var element in coordinates[0]) {
          if (element is List && element.length >= 2) {
            final double lon = element[0];
            final double lat = element[1];
            latLngList.add(gmaps.LatLng(lat, lon));
          }
        }
      }
    } catch (e) {
      print('Error parsing GeoJSON: $e');
    }

    return latLngList;
  }

  /// Add polygon to the Google Map
  void _addPolygonToMap() {
    final gmaps.Polygon polygon = gmaps.Polygon(
      polygonId: gmaps.PolygonId('polygon_$displayName'),
      fillColor: Colors.blue.withOpacity(0.2),
      points: polygonCoords,
      strokeColor: Colors.blueAccent,
      strokeWidth: 3,
    );

    setState(() {
      polygons.clear();
      polygons.add(polygon);
    });

    // Move the camera to the first coordinate
    if (polygonCoords.isNotEmpty) {
      mapController.animateCamera(
        gmaps.CameraUpdate.newLatLngZoom(polygonCoords[0], 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygon Fetcher - $displayName'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Input field for the place name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _placeController,
                    decoration: InputDecoration(
                      hintText: 'Enter place name (e.g., Chennai)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_placeController.text.isNotEmpty) {
                      _fetchData(_placeController.text);
                    }
                  },
                  child: const Text('Fetch'),
                ),
              ],
            ),
          ),

          // Google Map with polygons
          Expanded(
            child: gmaps.GoogleMap(
              initialCameraPosition: const gmaps.CameraPosition(
                target: gmaps.LatLng(20.5937, 78.9629), 
                zoom: 4,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              polygons: polygons,
            ),
          ),
        ],
      ),
    );
  }
}
