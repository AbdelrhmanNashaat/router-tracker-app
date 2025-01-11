import 'dart:convert';

import '../models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:http/http.dart' as http;

class GoogleMapsPlacesServices {
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String _apiKey = '';
  Future<List<PlaceModel>> getPlaceAutocomplete({required String input}) async {
    var response = await http.get(
        Uri.parse('$_baseUrl/autocomplete/json?key=$_apiKey&input=$input'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];
      List<PlaceModel> places = [];
      for (var place in data) {
        places.add(PlaceModel.fromJson(place));
      }
      return data.predictions;
    } else {
      throw Exception('Failed to load place autocomplete');
    }
  }
}
