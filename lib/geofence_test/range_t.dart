import 'package:currency_converter/geofence_test/geofence.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() => runApp(SearchApp());

class SearchApp extends StatelessWidget {
  const SearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchMap(),
    );
  }
}

class SearchMap extends StatefulWidget {
  const SearchMap({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchMapState createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(12.9396667, 80.1572500);
  double _range = 1000;
  bool _includeService = false;
  bool _excludeService = false;
  List<LatLng> _includedPlaces = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchStatus = "";
Circle? _geofenceCircle;
 final LatLng _center = const LatLng(12.9396667, 80.1572500);
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

 void _loadPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _range = prefs.getDouble('geofence_range') ?? 1000;
    _includeService = prefs.getBool('include_service') ?? false;
    _excludeService = prefs.getBool('exclude_service') ?? false;
    List<String>? includedLatLngs = prefs.getStringList('included_places');
    if (includedLatLngs != null) {
      _includedPlaces = includedLatLngs
          .map((e) {
            List<String> latLng = e.split(',');
            return LatLng(double.parse(latLng[0]), double.parse(latLng[1]));
          })
          .toList();
    }
    _updateGeofenceCircle();
  });
}

  void _updateGeofenceCircle() {
    setState(() {
      _geofenceCircle = Circle(
        circleId: const CircleId("geofence"),
        center: _center,
        radius: _range,
        fillColor: Colors.green.withOpacity(0.2),
        strokeColor: Colors.green,
        strokeWidth: 2,
      );
    });
  }



  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // in meters
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLng = _degreesToRadians(end.longitude - start.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _searchPlace(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng searchedPosition =
            LatLng(locations[0].latitude, locations[0].longitude);

        double distance = _calculateDistance(_initialPosition, searchedPosition);
        bool withinRange = distance <= _range;

        String message = "";
        if (_excludeService) {
          message = "Service not available (excluded).";
        } else if (_includeService) {
          if (_includedPlaces.any((place) =>
              _calculateDistance(place, searchedPosition) < 10)) {
            message = "Service available (included).";
          } else {
            message = "Service not available.";
          }
        } else {
          message = withinRange ? "Place is within range." : "Place is out of range.";
        }

        setState(() {
          _searchStatus = message;
        });

        _mapController.animateCamera(CameraUpdate.newLatLng(searchedPosition));
      }
    } catch (e) {
      setState(() {
        _searchStatus = "Error finding place.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geofence Search"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Geofence Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              title: const Text("Set Address Geofence Map"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const GeofenceApp()),
                );
              },
            ),
            ListTile(
              title: const Text("Geofence Map"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const SearchApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: 
      // Column(
      //   children: [
      //     Expanded(
      //       child: GoogleMap(
      //         onMapCreated: (controller) => _mapController = controller,
      //         initialCameraPosition: CameraPosition(
      //           target: _initialPosition,
      //           zoom: 14,
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           TextField(
      //             decoration: const InputDecoration(
      //               labelText: "Search Place",
      //               border: OutlineInputBorder(),
      //             ),
      //             controller: _searchController,
      //             onSubmitted: (value) {
      //               _searchPlace(value);
      //             },
      //           ),
      //           const SizedBox(height: 8),
      //           Text(
      //             _searchStatus,
      //             style: TextStyle(
      //               color: _searchStatus.contains("not") ? Colors.red : Colors.green,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Place',
                border: OutlineInputBorder(),
              ),
              controller: _searchController,
              onSubmitted: (value) {
                    _searchPlace(value);
                  },
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14,
              ),
              circles: _geofenceCircle != null ? {_geofenceCircle!} : {},
            ),
            
          ),
          Text(
                  _searchStatus,
                  style: TextStyle(
                    color: _searchStatus.contains("not") ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}
