import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MapWithPhoneRotation(),
  ));
}

class MapWithPhoneRotation extends StatefulWidget {
  @override
  _MapWithPhoneRotationState createState() => _MapWithPhoneRotationState();
}

class _MapWithPhoneRotationState extends State<MapWithPhoneRotation> {
  // ignore: unused_field
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  double _currentRotation = 0.0;
  LatLng _initialPosition = LatLng(0.0, 0.0); // Default position

  StreamSubscription? _sensorSubscription;
  AccelerometerEvent? _latestAccelerometer;
  MagnetometerEvent? _latestMagnetometer;
  BitmapDescriptor? _userIcon;

  @override
  void initState() {
    super.initState();
    _loadUserIcon();
    _addDefaultDestination();
    _getUserLocation();
  }

  void _loadUserIcon() async {
    _userIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(32, 32)),
      'assets/images/user_icon.png', // Replace with your custom icon
    );
    setState(() {});
  }

  void _addDefaultDestination() {
    LatLng defaultDestination = LatLng(48.8588443, 2.2943506); // Eiffel Tower
    Marker defaultMarker = Marker(
      markerId: MarkerId('defaultDestination'),
      position: defaultDestination,
      infoWindow: InfoWindow(title: "Default Destination"),
    );

    setState(() {
      _markers.add(defaultMarker);
    });
  }

  void _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      print("Location permission is denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _initialPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("userDestination"),
        position: _initialPosition,
        rotation: _currentRotation,
        icon: _userIcon ?? BitmapDescriptor.defaultMarker,
      ));
    });

    _startListeningToSensors();
  }

  void _startListeningToSensors() {
    _sensorSubscription = accelerometerEvents.listen((accelerometerEvent) {
      _latestAccelerometer = accelerometerEvent;
      _updateUserMarkerRotation();
    });

    magnetometerEvents.listen((magnetometerEvent) {
      _latestMagnetometer = magnetometerEvent;
      _updateUserMarkerRotation();
    });
  }

  void _updateUserMarkerRotation() {
    if (_latestAccelerometer != null && _latestMagnetometer != null) {
      double newRotation = _calculateOrientation(
        _latestAccelerometer!,
        _latestMagnetometer!,
      );

      double diff = newRotation - _currentRotation;
      if (diff.abs() > 0.5) {
        setState(() {
          _currentRotation = newRotation;
          _markers = _markers.map((marker) {
            if (marker.markerId.value == "userDestination") {
              return marker.copyWith(rotationParam: _currentRotation);
            }
            return marker;
          }).toSet();
        });
      }
    }
  }

  double _calculateOrientation(
      AccelerometerEvent accelerometer, MagnetometerEvent magnetometer) {
    double ax = accelerometer.x;
    double ay = accelerometer.y;
    double az = accelerometer.z;

    double normAccel = sqrt(ax * ax + ay * ay + az * az);
    ax /= normAccel;
    ay /= normAccel;
    az /= normAccel;

    double mx = magnetometer.x;
    double my = magnetometer.y;
    double mz = magnetometer.z;

    double normMag = sqrt(mx * mx + my * my + mz * mz);
    mx /= normMag;
    my /= normMag;
    mz /= normMag;

    double hx = my * az - mz * ay;
    double hy = mz * ax - mx * az;

    double heading = atan2(hy, hx) * (180 / pi);
    return (heading + 360) % 360;
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map with Rotating Marker")),
      body: _initialPosition.latitude == 0.0 && _initialPosition.longitude == 0.0
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14,
              ),
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
    );
  }
}
