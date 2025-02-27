import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;  // Alias for google_maps_flutter
// Assuming the 'Polygon' class you defined in your map_model.dart is the one used here

class MapModel {
  final String displayname;
  final Polygons polygon;

  MapModel({required this.displayname, required this.polygon});

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      displayname: json['display_name'] ?? 'Unknown Location',
      polygon: Polygons.fromJson(json['geojson'] ?? {}),
    );
  }
}

// Represents a collection of polygon coordinates
class Polygons {
  final List<gmaps.LatLng> coords;  // Use gmaps.LatLng to avoid conflict

  Polygons({required this.coords});

  factory Polygons.fromJson(Map<String, dynamic> json) {
    List<gmaps.LatLng> latlngList = [];

    try {
      final List<dynamic>? coordinates = json['coordinates'];
      if (coordinates != null && coordinates.isNotEmpty) {
        // Assuming geojson has a Polygon structure (outer array contains one polygon)
        for (var element in coordinates[0]) {
          if (element is List && element.length >= 2) {
            final double lon = element[0];
            final double lat = element[1];
            latlngList.add(gmaps.LatLng(lat, lon));  // Use gmaps.LatLng to avoid conflict
          }
        }
      } else {
        print('GeoJSON coordinates are empty or null.');
      }
    } catch (e) {
      print('Error parsing GeoJSON coordinates: $e');
    }

    return Polygons(coords: latlngList);
  }
}
