import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_key.dart';

Future<String> getPlaceName(double lat, double lng) async {
  // URL do Google Places API
  String url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey';

  try {
    var response = await http.get(Uri.parse(url));
    print('API Response: ${response.body}'); // Dodane do debugowania

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      // Sprawdzenie, czy są jakieś wyniki
      if (jsonResponse['results'].isEmpty) {
        print('No results found for the given location.');
        return 'Unknown Location';
      }

      var result = jsonResponse['results'][0]['formatted_address'];
      return result;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return 'Unknown Place';
    }
  } catch (e) {
    print('Error: $e');
    return 'Unknown Place';
  }
}
