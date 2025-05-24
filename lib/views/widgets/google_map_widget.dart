import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracking_app/models/location_info/lat_lng.dart';
import 'package:route_tracking_app/models/location_info/location_info.dart';
import 'package:route_tracking_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracking_app/models/place_details_model/place_details_model.dart';
import 'package:route_tracking_app/utils/google_maps_places_services.dart';
import 'package:route_tracking_app/utils/routes_service.dart';
import 'package:uuid/uuid.dart';
import '../../models/location_info/location.dart' show LocationModel;
import '../../models/routes_model/route.dart' show RouteModel;
import '../../utils/location_services.dart';
import 'custom_text_filed.dart';
import 'search_result_widget.dart';

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
  late Uuid uuid;
  String? sessionToken;
  PlaceDetailsModel? placeModel;
  Set<Marker> markers = {};
  List<PlaceModel> places = [];
  late RoutesService routesService;
  late LatLng currentLocation;
  late LatLng destinationLocation;
  Set<Polyline> polylines = {};
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    locationService = LocationServices();
    searchController = TextEditingController();
    googleMapsPlacesServices = GoogleMapsPlacesServices();
    uuid = const Uuid();
    routesService = RoutesService();
    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    sessionToken ??= uuid.v4();
    searchController.addListener(
      () async {
        log(searchController.text);
        if (searchController.text.isNotEmpty) {
          var predictions = await googleMapsPlacesServices.getPredictions(
            input: searchController.text,
            sessionToken: sessionToken!,
          );
          places.clear();
          places.addAll(predictions);
          setState(() {});
        } else {
          places.clear();
          setState(() {});
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
          child: Column(
            children: [
              CustomTextFiled(
                searchController: searchController,
              ),
              const SizedBox(height: 16),
              SearchResultsWidget(
                places: places,
                googleMapsPlaces: googleMapsPlacesServices,
                onPlaceSelect: (PlaceDetailsModel placeModel) async {
                  searchController.clear();
                  places.clear();
                  this.placeModel = placeModel;
                  sessionToken = null;
                  setState(() {});
                  destinationLocation = LatLng(
                    placeModel.geometry!.location!.lat!,
                    placeModel.geometry!.location!.lng!,
                  );
                  getRouteData();
                },
              ),
            ],
          ),
        ),
        GoogleMap(
          polylines: polylines,
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
      LatLng currentLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      CameraPosition cameraPosition = CameraPosition(
        target: currentLocation,
        zoom: 16,
      );
      Marker marker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentLocation,
      );
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      markers.add(marker);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<RouteModel> getRouteData() async {
    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude),
      ),
    );
    LocationInfoModel destination = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: destinationLocation.latitude,
          longitude: destinationLocation.longitude,
        ),
      ),
    );

    var routes = await routesService.fetchRoutes(
      origin: origin,
      destination: destination,
    );
    return routes.routes!.first;
  }
}
