import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; 
import 'package:permission_handler/permission_handler.dart';
import 'package:liteline/utils/helpers.dart'; 

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({super.key});

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  GoogleMapController? _mapController;
  final LatLng _initialCameraPosition = const LatLng(-6.2088, 106.8456); 
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addInitialMarker();
    _determinePosition();
  }

  void _addInitialMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('initialLocation'),
        position: _initialCameraPosition,
        infoWindow: const InfoWindow(title: 'Jakarta, Indonesia'),
      ),
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast(context, 'Location services are disabled.', backgroundColor: Colors.red);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast(context, 'Location permissions are denied.', backgroundColor: Colors.red);
        showCustomAlert(
          context,
          title: 'Permission Required',
          message: 'Please grant location permission from app settings to use this feature.',
          confirmText: 'Open Settings',
          cancelText: 'Cancel',
          onConfirm: () {
            openAppSettings();
          },
          icon: Icons.info_outline,
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToast(context, 'Location permissions are permanently denied, we cannot request permissions.', backgroundColor: Colors.red);
      showCustomAlert(
        context,
        title: 'Permission Required',
        message: 'Location permissions are permanently denied. Please enable them manually from app settings.',
        confirmText: 'Open Settings',
        cancelText: 'Cancel',
        onConfirm: () {
          openAppSettings();
        },
        icon: Icons.info_outline,
      );
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'My Current Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
      showToast(context, 'Current location loaded!');
    } catch (e) {
      showToast(context, 'Could not get current location: $e', backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialCameraPosition,
          zoom: 12.0,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _determinePosition,
        child: const Icon(Icons.my_location),
        backgroundColor: Colors.blue.shade700,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}