import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // google_maps
import 'package:geocoding/geocoding.dart'; //for location
import 'package:flutter_google_maps_webservices/places.dart' as googlePlaces; //for places
import 'dart:math';

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
  final LatLng _initialPosition = const LatLng(12.9396667, 80.1572500);
  double _range = 1000;
  Circle? _geofenceCircle;
  final Set<Circle> _circles = {};
  final List<String> includedPins = [];
  final List<String> excludedPins = [];
  late TextEditingController _addressController;

  //autocomple
  final _placesApiClient = googlePlaces.GoogleMapsPlaces(
      apiKey: "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs");
  List<googlePlaces.Prediction> _autocompleteResults = [];

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _updateGeofenceCircle();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _updateGeofenceCircle() {
    setState(() {
      _geofenceCircle = Circle(
        circleId: const CircleId("geofence"),
        center: _initialPosition,
        radius: _range,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      );
      _circles.add(_geofenceCircle!);
    });
  }

  void _searchAddress(String address, bool isInclude) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng position = LatLng(locations[0].latitude, locations[0].longitude);
        double distance = _calculateDistance(_initialPosition.latitude,
            _initialPosition.longitude, position.latitude, position.longitude);

        if (distance > _range) {
          // Show message if the address is out of range
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Address is out of range.")),
          );
          return; // Exit early if out of range
        }
        setState(() {
          String action = isInclude ? "Include" : "Exclude";

          // Remove any existing circle for the address
          _circles.removeWhere((circle) =>
              circle.circleId.value == "include_$address" ||
              circle.circleId.value == "exclude_$address");

          if (isInclude) {
            // Add to includedPins if not already present
            if (!includedPins.contains(address)) {
              includedPins.add(address);
            }
            // Remove from excludedPins if present
            excludedPins.remove(address);

            // Add green circle
            _circles.add(Circle(
              circleId: CircleId("include_$address"),
              center: position,
              radius: 100,
              fillColor:
                  const Color.fromARGB(255, 11, 202, 17).withOpacity(0.5),
              strokeColor: const Color.fromARGB(255, 8, 214, 15),
              strokeWidth: 2,
            ));
          } else {
            // Add to excludedPins if not already present
            if (!excludedPins.contains(address)) {
              excludedPins.add(address);
            }
            // Remove from includedPins if present
            includedPins.remove(address);

            // Add red circle
            _circles.add(Circle(
              circleId: CircleId("exclude_$address"),
              center: position,
              radius: 100,
              fillColor: Colors.red.withOpacity(0.5),
              strokeColor: Colors.red,
              strokeWidth: 2,
            ));
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$action action performed for $address.")),
          );
        });

        // Move camera to the position
        _mapController.animateCamera(CameraUpdate.newLatLng(position));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address not found.")),
      );
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double pi = 3.1415926535897932;
    const double radius = 6371000; // Earth radius in meters
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c; // Distance in meters
  }

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

  void _onPlaceSelected(googlePlaces.Prediction result) async {
    final details = await _placesApiClient.getDetailsByPlaceId(result.placeId!);

    if (details.result.geometry != null) {
      // final lat = details.result.geometry!.location.lat;
      // final lng = details.result.geometry!.location.lng;

      setState(() {
        // _selectedPosition = LatLng(lat, lng);
        _autocompleteResults = [];
        _addressController.text = result.description!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Geofence Map"),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              //goofle map
              child: GoogleMap( 
                onMapCreated: (controller) => _mapController = controller,
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14,
                ),
                circles: _circles,
                markers: {
                  Marker(
                    markerId: const MarkerId("default"),
                    position: _initialPosition,
                    infoWindow: const InfoWindow(title: "Default Destination"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration:
                          const InputDecoration(labelText: "Set Range (meters)"),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        setState(() {
                          _range = double.tryParse(value) ?? _range;
                          _updateGeofenceCircle();
                        });
                      },
                    ),
                   
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      onChanged: _onSearchChanged,
                      decoration: const InputDecoration(
                          labelText: "Search Address or Pin Code"),
                      controller: _addressController,
                    ),
                     if (_autocompleteResults.isNotEmpty)
                      Container(
                        color: Colors.white,
                        
                          height: 150,
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
                    const SizedBox(height: 8),
                    //Include and Exclude Buttong
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_addressController.text.isNotEmpty) {
                                _searchAddress(_addressController.text, true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text("Include",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_addressController.text.isNotEmpty) {
                                _searchAddress(_addressController.text, false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("Exclude",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                
                    //Include List
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Include Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Include",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                            
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: includedPins.map((pin) {
                                    return InputChip(
                                      label: Text(pin),
                                      onDeleted: () {
                                        setState(() {
                                          includedPins.remove(pin);
                                          _circles.removeWhere((circle) =>
                                              circle.circleId.value ==
                                              "include_$pin");
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                
                          const SizedBox(width: 16),
                
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Exclude",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                                             Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: excludedPins.map((pin) {
                                    return InputChip(
                                      label: Text(pin),
                                      onDeleted: () {
                                        setState(() {
                                          excludedPins.remove(pin);
                                          _circles.removeWhere((circle) =>
                                              circle.circleId.value ==
                                              "exclude_$pin");
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
