import 'dart:convert';
import 'package:route_tracking_app/models/place_details_model/place_details_model.dart';

import '../models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:http/http.dart' as http;

class GoogleMapsPlacesServices {
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String _apiKey = '';
  Future<List<PlaceModel>> getPredictions(
      {required String input, required String sessionToken}) async {
    var response = await http.get(Uri.parse(
        '$_baseUrl/autocomplete/json?key=$_apiKey&input=$input&sessiontoken=$sessionToken'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];
      List<PlaceModel> places = [];
      for (var place in data) {
        places.add(PlaceModel.fromJson(place));
      }
      return places;
    } else {
      throw Exception('Failed to load place autocomplete');
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    var response = await http.get(
        Uri.parse('$_baseUrl/details/json?key=$_apiKey&place_id=$placeId'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['result'];
      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
