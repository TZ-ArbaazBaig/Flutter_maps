import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geojson/geojson.dart';

void main()
{
  runApp(const MaterialApp(
    home: Chartsection(),
  ));
}

class Chartsection extends StatelessWidget {
const Chartsection({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      home: DynamicPolygonMap(),
    );
  }
}



class DynamicPolygonMap extends StatefulWidget {
  @override
  _DynamicPolygonMapState createState() => _DynamicPolygonMapState();
}

class _DynamicPolygonMapState extends State<DynamicPolygonMap> {
  final Set<Polygon> _polygons = {};
  late GoogleMapController _mapController;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  // Fetch polygon data for a given place name
Future<List<LatLng>> fetchPlacePolygon(String placeName) async {
  final url =
      'https://overpass-api.de/api/interpreter?data=[out:json];relation[name="$placeName"];out geom;';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    // Check if "elements" key exists and is a list
    if (data.containsKey('elements') && data['elements'] is List) {
      final elements = data['elements'] as List;

      // Find the element with "geometry" key
      for (final element in elements) {
        if (element is Map<String, dynamic> && element.containsKey('geometry')) {
          final geometry = element['geometry'] as List;

          // Map the geometry to LatLng coordinates
          return geometry
              .map((point) => LatLng(
                    point['lat'] as double,
                    point['lon'] as double,
                  ))
              .toList();
        }
      }
    }

    throw Exception('No geometry data found for the place.');
  } else {
    throw Exception('Failed to load polygon data (HTTP ${response.statusCode})');
  }
}



  // Draw polygon on the map
  Future<void> _fetchAndDrawPolygon(String placeName) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final coordinates = await fetchPlacePolygon(placeName);
      setState(() {
        _polygons.clear(); // Clear existing polygons
        _polygons.add(
          Polygon(
            polygonId: PolygonId(placeName),
            points: coordinates,
            fillColor: Colors.blue.withOpacity(0.3),
            strokeColor: Colors.blue,
            strokeWidth: 2,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch polygon data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Place Polygon"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _fetchAndDrawPolygon("Bangalore"); // Default to Bangalore
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(12.9716, 77.5946), // Center of Bangalore
              zoom: 12,
            ),
            polygons: _polygons,
            onMapCreated: (controller) => _mapController = controller,
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_errorMessage.isNotEmpty)
            Center(
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          // Example: Fetch polygon for a user-defined place
          final placeName = await _promptPlaceName(context);
          if (placeName != null && placeName.isNotEmpty) {
            _fetchAndDrawPolygon(placeName);
          }
        },
      ),
    );
  }

  // Dialog to input a place name
  Future<String?> _promptPlaceName(BuildContext context) async {
    String? placeName;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Place Name"),
          content: TextField(
            onChanged: (value) {
              placeName = value;
            },
            decoration: InputDecoration(hintText: "e.g., Bangalore"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    return placeName;
  }
}
