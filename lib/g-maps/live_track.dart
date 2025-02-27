import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:currency_converter/g-maps/marker_icon.dart';
import 'package:curarency_converter/sideBar.dart';
import 'package:currency_converter/sideBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';


class LiveTrack extends StatefulWidget {
  const LiveTrack({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LiveTrackState createState() => _LiveTrackState();
}

class _LiveTrackState extends State<LiveTrack> {
  LatLng? originLatLng=const LatLng(0.0, 0.0);
  LatLng? destinationLatLng = const LatLng(
      12.939304, 80.158018); // Default destination
      

  CameraPosition? initialCameraPosition;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {}; // Set to store polylines

  List<LatLng> polylineCoordinates = []; // List for polyline coordinates
  PolylinePoints polylinePoints = PolylinePoints();

  Set<Circle> circles = {};
  BitmapDescriptor? liveLocationMarker;
  GoogleMapController? mapController;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  // Variables to track distance
  double _distanceTravelled = 0.0;
  Position? _previousPosition;

  String distancee = "";
  String destination = "";

  double? totalDistance;

//add
StreamSubscription? _sensorSubscription;
  AccelerometerEvent? _latestAccelerometer;
  MagnetometerEvent? _latestMagnetometer;

 double _currentRotation = 0.0;
  bool hasReachedDestination=false;



   String googleApiKey =
        "AIzaSyBhL5rK2MXq8piHqNLxRDBEhE2gkGmkfjs"; 

  @override
  void initState() {
    super.initState();
    _determinePosition();
    // _startHeadingListener();

    // Add the destination marker
    if (destinationLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLatLng!,
          infoWindow: const InfoWindow(title: 'Default Destination'),
        ),
      );

      // Add polyline between origin and destination
      polylineCoordinates.add(destinationLatLng!);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (originLatLng != null && destinationLatLng != null) {
      totalDistance = _calculateDistance(originLatLng!, destinationLatLng!) /
          1000; 
    }
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      drawer: Sidebar(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text("Live Location Tracking"),
      ),
      body: initialCameraPosition == null
          ? const Center(
              child:
                  CircularProgressIndicator()) 
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition!,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              zoomGesturesEnabled: true,
              markers: markers,
              polylines: polylines,
              circles: circles,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location_outlined),
        onPressed: () {
          if (originLatLng != null) {
            mapController
                ?.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 16));
          }
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensure it doesn't take too much space
          children: [
            Text(
              'Total Distance Travelled: ${(_distanceTravelled / 1000).toStringAsFixed(2)} km', // Convert to km
              style: const TextStyle(fontSize: 18),
            ),
            if (totalDistance != null)
              Text(
                'Remaining Distance: ${totalDistance!.toStringAsFixed(2)} km',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for permissions
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Set location settings based on platform
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 4,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "This app will continue to receive your location even when you aren't using it",
          notificationTitle: "Location Tracking",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 4,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else if (kIsWeb) {
      locationSettings = WebSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        maximumAge: const Duration(minutes: 5),
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    await getBytesFromAsset('assets/images/car_icon1.png', 150).then((value) {
      setState(() {
        liveLocationMarker = value;
      });
    }
    );
    

    // Get location updates
    _geolocatorPlatform
        .getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      if (position != null) {
         LatLng newLatLng = LatLng(position.latitude, position.longitude);
        
        LatLng snappedLatLng = await _snapToRoad(newLatLng);
      // Ensure the car doesn't jump if the distance is too small
      if (_previousPosition != null) {
        double distance = Geolocator.distanceBetween(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        // Set a threshold for significant movement (e.g., 10 meters)
        if (distance < 10) return; // Skip update if the movement is small
      }

      // Update the origin location
      originLatLng = snappedLatLng;
      _previousPosition = position;
        initialCameraPosition = CameraPosition(target: originLatLng!, zoom: 15);

 
        markers.removeWhere(
            (element) => element.mapsId.value.compareTo("origin") == 0);
        markers.add(Marker(
          markerId: const MarkerId('origin'),
          position: originLatLng!,
          // rotation: _currentLocation,
          icon: liveLocationMarker!,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ));

// Add or update circle around the user
        circles.clear();
        circles.add(Circle(
          circleId: const CircleId('user_circle'),
          center: originLatLng!,
          radius: 30, // Circle with 30m radius
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ));

        // Calculate distance between current and previous position
        if (_previousPosition != null) {
          double distance = Geolocator.distanceBetween(
            _previousPosition!.latitude,
            _previousPosition!.longitude,
            position.latitude,
            position.longitude,
          );

          setState(() {
            _distanceTravelled += distance;
          });
        }

        _previousPosition = position;
        if (!hasReachedDestination) {
        _checkIfReachedDestination();
      }

        // Fetch directions and update polyline
        await _getDirections();

        setState(() {}); // Trigger a rebuild to update UI
      }
    });
    _startListeningToSensors();
  }
  
 Future<LatLng> _snapToRoad(LatLng currentPosition) async {
  // final String googleApiKey = "YOUR_GOOGLE_API_KEY"; // Replace with your actual API key

  // Construct the URL for the Snap to Roads API
  final response = await http.get(Uri.parse(
      'https://roads.googleapis.com/v1/snapToRoads?path=${currentPosition.latitude},${currentPosition.longitude}&key=$googleApiKey'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['snappedPoints'] != null && data['snappedPoints'].isNotEmpty) {
      var snappedPoint = data['snappedPoints'][0];
      double lat = snappedPoint['location']['latitude'];
      double lng = snappedPoint['location']['longitude'];

      // Return the snapped position to stay on the road
      return LatLng(lat, lng);
    }
  }

  // If API fails or no data found, return the current position
  return currentPosition;
}


  void _showReachedDestinationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You have reached your destination!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
 void _checkIfReachedDestination() {
  double distanceToDestination = Geolocator.distanceBetween(
    originLatLng!.latitude,
    originLatLng!.longitude,
    destinationLatLng!.latitude,
    destinationLatLng!.longitude,
  );

 
  if (distanceToDestination <= 10) {
    // Show dialog and prevent further popups
    _showReachedDestinationDialog();
    hasReachedDestination = true; 
  }
}


 /// Start listening to accelerometer and magnetometer streams
  void _startListeningToSensors() {
    _sensorSubscription = accelerometerEvents.listen((accelerometerEvent) {
      _latestAccelerometer = accelerometerEvent;
      _updateMarkerRotation();
    });

    magnetometerEvents.listen((magnetometerEvent) {
      _latestMagnetometer = magnetometerEvent;
      _updateMarkerRotation();
    });
  }


void _updateMarkerRotation() {
    if (_latestAccelerometer != null && _latestMagnetometer != null) {
      double newRotation = _calculateOrientation(
        _latestAccelerometer!,
        _latestMagnetometer!,
      );

      // Interpolate the rotation smoothly instead of abrupt changes
      double diff = newRotation - _currentRotation;
      if (diff.abs() > 0.5) { // Only update if the change is significant enough
        // Interpolate between the current rotation and the new rotation
        // This ensures smooth transitions.
        double interpolationSpeed = 0.1; // Adjust the speed for smoother transitions
        if (diff > 180) {
          diff -= 360;
        } else if (diff < -180) {
          diff += 360;
        }

        double smoothRotation = _currentRotation + diff * interpolationSpeed;

        // setState(() {
        //   _currentRotation = smoothRotation;
        //   if (markers.first != null) {
        //     markers.first = markers.first!.copyWith(rotationParam: _currentRotation);
        //   }
        // });

setState(() {
        _currentRotation = smoothRotation;

        // Update the marker's rotation
        markers.removeWhere((marker) => marker.markerId.value == 'origin');
        markers.add(Marker(
          markerId: const MarkerId('origin'),
          position: originLatLng!,  // Update the marker's position
          icon: liveLocationMarker!, // Your car icon
          rotation: _currentRotation, // Apply the rotation here
          infoWindow: const InfoWindow(title: 'Current Location'),
        ));
      });

      }
    }
  }


  /// Calculate the phone's orientation in degrees
  double _calculateOrientation(
    AccelerometerEvent accelerometer, MagnetometerEvent magnetometer) {
    // Normalize accelerometer data
    double ax = accelerometer.x;
    double ay = accelerometer.y;
    double az = accelerometer.z;

    double normAccel = sqrt(ax * ax + ay * ay + az * az);
    ax /= normAccel;
    ay /= normAccel;
    az /= normAccel;

    // Normalize magnetometer data
    double mx = magnetometer.x;
    double my = magnetometer.y;
    double mz = magnetometer.z;

    double normMag = sqrt(mx * mx + my * my + mz * mz);
    mx /= normMag;
    my /= normMag;
    mz /= normMag;

    // Compute horizontal components
    double hx = my * az - mz * ay;
    double hy = mz * ax - mx * az;

    // Calculate heading (rotation in degrees)
    double heading = atan2(hy, hx) * (180 / pi);

    // Normalize heading to range [0, 360]
    return (heading + 360) % 360;
  }





  double _calculateDistance(LatLng start, LatLng end) {
    double distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
    return distanceInMeters;
  }

 
  Future<void> _getDirections() async {

    if (originLatLng != null && destinationLatLng != null) {
      final response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originLatLng!.latitude},${originLatLng!.longitude}&destination=${destinationLatLng!.latitude},${destinationLatLng!.longitude}&key=$googleApiKey",
      ));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'OK') {
          var points = PolylinePoints()
              .decodePolyline(data['routes'][0]['overview_polyline']['points']);

          if (points.isNotEmpty) {
            polylineCoordinates.clear();
            polylineCoordinates.addAll(
                points.map((point) => LatLng(point.latitude, point.longitude)));

            polylines.add(Polyline(
              polylineId: const PolylineId('route'),
              color: Colors.blue,
              width: 5,
              points: polylineCoordinates,
            ));

             _updateCarOnRoute(polylineCoordinates);

            setState(() {});
          }
        } else {
          debugPrint('Directions API Error: ${data['status']}');
        }
      } else {
        debugPrint('HTTP Error: ${response.statusCode}');
      }
    }
  }
  void _updateCarOnRoute(List<LatLng> routePoints) {
  // If the car has reached the end of the route, stop updating
  if (hasReachedDestination) return;

  // Find the nearest point on the polyline to the car's current position
  double minDistance = double.infinity;
  LatLng nearestPoint = routePoints[0];

  for (LatLng point in routePoints) {
    double distance = _calculateDistance(originLatLng!, point);
    if (distance < minDistance) {
      minDistance = distance;
      nearestPoint = point;
    }
  }

  // Move the car marker to the nearest point on the route
  setState(() {
    markers.removeWhere((marker) => marker.markerId.value == 'origin');
    markers.add(Marker(
      markerId: const MarkerId('origin'),
      position: nearestPoint,  // Update to the nearest point on the polyline
      icon: liveLocationMarker!,
      infoWindow: const InfoWindow(title: 'Current Location'),
    ));
  });
}

}
