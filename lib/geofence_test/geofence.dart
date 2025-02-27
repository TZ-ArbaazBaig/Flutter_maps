import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const GeofenceApp());

class GeofenceApp extends StatelessWidget {
  const GeofenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeofenceMap(),
    );
  }
}

class GeofenceMap extends StatefulWidget {
  const GeofenceMap({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GeofenceMapState createState() => _GeofenceMapState();
}

class _GeofenceMapState extends State<GeofenceMap> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition =const LatLng(12.9396667, 80.1572500); 
  double _range = 1000; 
  Circle? _geofenceCircle;
  Marker? _addressMarker;
  String _serviceStatus = "";
  bool _includeService = false;
  bool _excludeService = false;
  String _address = "";
  late TextEditingController _addressController;
  final List<LatLng> _includedPlaces = [];

  final Marker _initialMarker = Marker(
    markerId:const MarkerId("default"),
    position:const LatLng(12.9396667, 80.1572500),
    infoWindow:const InfoWindow(title: "Default Destination"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  );




void _savePreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('geofence_range', _range);
  await prefs.setBool('include_service', _includeService);
  await prefs.setBool('exclude_service', _excludeService);
  List<String> includedLatLngs =
      _includedPlaces.map((place) => "${place.latitude},${place.longitude}").toList();
  await prefs.setStringList('included_places', includedLatLngs);
}

@override
void dispose() {
    _addressController.dispose();
  _savePreferences();
  super.dispose();
}



  @override
  void initState() {
    _addressController = TextEditingController();
    _updateGeofenceCircle();
    super.initState();
  }


  void _updateGeofenceCircle() {
    setState(() {
      _geofenceCircle = Circle(
        circleId:const CircleId("geofence"),
        center: _initialPosition,
        radius: _range,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      );
    });
  }

  // void _updateMarkerAndAddress(LatLng position) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks.first;
  //       setState(() {
  //         _address = "${place.name}, ${place.subLocality}, ${place.locality}, "
  //             "${place.administrativeArea}, ${place.postalCode}, ${place.country}";
  //         _addressController.text = _address;

  //         _addressMarker = Marker(
  //           markerId:const MarkerId("updated"),
  //           position: position,
  //           infoWindow:const InfoWindow(title: "Selected Address"),
  //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //         );
  //         _checkServiceAvailability(position);
  //       });
  //     }
  //   } catch (e) {
  //     if(mounted){
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error fetching address.")));

  //     }
  //   }
  // }
  void _updateMarkerAndAddress(LatLng position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _address = "${place.name}, ${place.subLocality}, ${place.locality}, "
            "${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        _addressController.text = _address;

        _addressMarker = Marker(
          markerId: const MarkerId("updated"),
          position: position,
          infoWindow: const InfoWindow(title: "Selected Address"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );

        if (_includeService) {
          // Add the position to the included places
          _includedPlaces.add(position);
        }
        _checkServiceAvailability(position);
      });
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching address.")),
      );
    }
  }
}


  void _searchAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng searchedPosition = LatLng(locations[0].latitude, locations[0].longitude);
        _updateMarkerAndAddress(searchedPosition);
        _mapController.animateCamera(CameraUpdate.newLatLng(searchedPosition));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Address not found.")));
    }
  }

  void _checkServiceAvailability(LatLng position) {
    double distance = _calculateDistance(_initialPosition, position);
    bool withinRange = distance <= _range;

    if (_excludeService) {
      _serviceStatus = "Service not available (excluded).";
    } else if (_includeService) {
      _serviceStatus = "Service available (included).";
    } 
    else {
      _serviceStatus = withinRange ? "Service available." : "Service not available.";
    }

    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Geofence Map"),
      ),
      drawer: const Drawer(
        
      ),

      body: Column(
        children: [
 
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14,
              ),
              circles: _geofenceCircle != null ? {_geofenceCircle!} : {},
              markers: {
                _initialMarker,
                if (_addressMarker != null) _addressMarker!,
              },
              onTap: (LatLng position) {
                _updateMarkerAndAddress(position);
              },
            ),
          ),
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration:const InputDecoration(labelText: "Set Range (meters)"),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    setState(() {
                      _range = double.tryParse(value) ?? _range;
                      _updateGeofenceCircle();
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration:const InputDecoration(labelText: "Search Address or Pin Code"),
                  controller: _addressController,
                  onSubmitted: _searchAddress,
                  // minLines: 3,
                  // maxLines: null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _includeService,
                      onChanged: (value) {
                        setState(() {
                          _includeService = value ?? false;
                          _excludeService = false;
                        });
                      },
                    ),
                   const Text("Include"),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _excludeService,
                      onChanged: (value) {
                        setState(() {
                          _excludeService = value ?? false;
                          _includeService = false;
                        });
                      },
                    ),
                   const Text("Exclude"),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _serviceStatus,
                  style: TextStyle(
                    color: _serviceStatus.contains("not") ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
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
