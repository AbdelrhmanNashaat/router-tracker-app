import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracking_app/utils/google_maps_places_services.dart';
import '../../utils/location_services.dart';
import 'custom_text_filed.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialCameraPosition;
  late LocationServices locationService;
  late GoogleMapController mapController;
  late TextEditingController searchController;
  late GoogleMapsPlacesServices googleMapsPlacesServices;
  Set<Marker> markers = {};
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    locationService = LocationServices();
    searchController = TextEditingController();
    googleMapsPlacesServices = GoogleMapsPlacesServices();
    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    searchController.addListener(
      () async {
        log(searchController.text);
        if (searchController.text.isNotEmpty) {
          var predictions = await googleMapsPlacesServices.getPredictions(
            input: searchController.text,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: CustomTextFiled(
            searchController: searchController,
          ),
        ),
        GoogleMap(
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            updateCurrentLocation(); // call this method here to be sure that the map is created
          },
          zoomControlsEnabled: false,
          initialCameraPosition: initialCameraPosition,
        ),
      ],
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
