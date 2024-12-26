import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'utils/location_services.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleMapView(),
    );
  }
}

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialCameraPosition;
  late LocationServices locationService;
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    locationService = LocationServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        updateCurrentLocation(); // call this method here to be sure that the map is created
      },
      zoomControlsEnabled: false,
      initialCameraPosition: initialCameraPosition,
    );
  }

  void updateCurrentLocation() async {
    try {
      var locationData = await locationService.getLocation();
      var currentPosition = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      CameraPosition cameraPosition = CameraPosition(
        target: currentPosition,
        zoom: 16,
      );
      Marker marker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentPosition,
      );
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      markers.add(marker);
    } catch (e) {
      log(e.toString());
    }
  }
}
