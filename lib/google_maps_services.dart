import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs';  // Your API key here

class GoogleMapsServices {
  // Method to get route coordinates (encoded polyline) from Google Maps Directions API
  Future<String> getRouteCoordinates(LatLng origin, LatLng destination) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";

    // Making the GET request to the Google Maps Directions API
    http.Response response = await http.get(Uri.parse(url));

    // Decoding the response body into a Map
    Map values = jsonDecode(response.body);

    // Returning the encoded polyline points
    return values["routes"][0]["overview_polyline"]["points"];
  }
}
