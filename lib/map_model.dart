import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapModel {
  final String displayName;
  final Polygon polygon;

  MapModel({required this.displayName, required this.polygon});

  /// Factory method to create a MapModel instance from JSON
  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      displayName: json['display_name'] ?? 'Unknown Location',
      polygon: Polygon.fromJson(json['geojson'] ?? {}),
    );
  }
}

/// Represents a polygon with a list of LatLng coordinates
class Polygon {
  final List<LatLng> coords;

  Polygon({required this.coords});

  /// Factory method to create a Polygon instance from JSON
  factory Polygon.fromJson(Map<String, dynamic> json) {
    final List<LatLng> latLngList = [];
    try {
      // Validate and parse coordinates
      final List<dynamic>? coordinates = json['coordinates'];
      if (coordinates != null && coordinates.isNotEmpty && coordinates[0] is List) {
        for (var element in coordinates[0]) {
          if (element is List && element.length >= 2) {
            final double lon = element[0];
            final double lat = element[1];
            latLngList.add(LatLng(lat, lon));
          }
        }
      }
    } catch (e) {
      print('Error parsing polygon coordinates: $e');
    }
    return Polygon(coords: latLngList);
  }
}
