import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyPlacesScreen extends StatefulWidget {
  @override
  _NearbyPlacesScreenState createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
  // Default latitude and longitude (Center point)
  double defaultLatitude =  13.063824;
  double defaultLongitude = 80.269360;
// 13.063824, 80.269360
  // List to hold nearby places
  List<String> _nearbyPlaces = [];

  // Function to fetch nearby places from Google Places API
  Future<void> _fetchNearbyPlaces(double latitude, double longitude) async {
    const String apiKey = "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs"; // Add your Google Maps API Key here
    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=20000&type=restaurant&key=$apiKey"; // 20 km radius

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final places = data['results'] as List;

      setState(() {
        _nearbyPlaces = places
            .map((place) => place['name'] as String)
            .toList(); // Extract place names from the response
      });
    } else {
      setState(() {
        _nearbyPlaces = ["Error fetching places"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch nearby places with the default coordinates when the app starts
    _fetchNearbyPlaces(defaultLatitude, defaultLongitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Places')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Show the current coordinates (center of search area)
            Text(
              "Latitude: $defaultLatitude, Longitude: $defaultLongitude",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select a Place'),
                value: _nearbyPlaces.isNotEmpty ? _nearbyPlaces[0] : null,
                items: _nearbyPlaces.map((place) {
                  return DropdownMenuItem<String>(
                    value: place,
                    child: Text(place),
                  );
                }).toList(),
                onChanged: (value) {
                  // You can add additional logic here when a place is selected
                  setState(() {
                    // You can do something with the selected value
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NearbyPlacesScreen(),
  ));
}
