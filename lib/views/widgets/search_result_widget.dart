import 'package:flutter/material.dart';

import '../../models/place_autocomplete_model/place_autocomplete_model.dart';
import '../../models/place_details_model/place_details_model.dart'
    show PlaceDetailsModel;
import '../../utils/google_maps_places_services.dart';

class SearchResultsWidget extends StatelessWidget {
  final GoogleMapsPlacesServices googleMapsPlaces;
  final void Function(PlaceDetailsModel) onPlaceSelect;
  final List<PlaceModel> places;
  const SearchResultsWidget({
    super.key,
    required this.places,
    required this.googleMapsPlaces,
    required this.onPlaceSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index].description!),
            leading: const Icon(Icons.location_on),
            trailing: IconButton(
              onPressed: () async {
                var placeDetails = await googleMapsPlaces.getPlaceDetails(
                  placeId: places[index].placeId!.toString(),
                );
                onPlaceSelect(placeDetails);
              },
              icon: const Icon(Icons.arrow_circle_right_rounded),
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(
          color: Colors.grey,
          height: 0,
        ),
        itemCount: places.length,
      ),
    );
  }
}
