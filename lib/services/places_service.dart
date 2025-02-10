// First create a new file called lib/services/places_service.dart
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlacesService {
  static const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  
  // static String get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';  
  final String _apiKey='AIzaSyBzDnudfbtQegKHsECZ2ND-NQofYECKPzo';
  //removed static here
  Future<List<PlaceSearchResult>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    final url = '$baseUrl/autocomplete/json?input=$query&types=address&key=$_apiKey';
    log(url);
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        log('RESPONSE IS 2000000000');
        log(response.body);
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List;
        
        return predictions.map((place) => PlaceSearchResult(
          placeId: place['place_id'],
          description: place['description'],
          mainText: place['structured_formatting']['main_text'],
          secondaryText: place['structured_formatting']['secondary_text'],
        )).toList();
      }
      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }
//removed static here 
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    final url = '$baseUrl/details/json?place_id=$placeId&key=$_apiKey';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];
        
        return PlaceDetails(
          placeId: placeId,
          address: result['formatted_address'],
          latitude: result['geometry']['location']['lat'],
          longitude: result['geometry']['location']['lng'],
        );
      }
      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }
}

class PlaceSearchResult {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlaceSearchResult({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
}

class PlaceDetails {
  final String placeId;
  final String address;
  final double latitude;
  final double longitude;

  PlaceDetails({
    required this.placeId,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}