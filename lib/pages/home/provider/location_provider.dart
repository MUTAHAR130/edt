// 
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  LatLng? _currentLocation;
  double _currentLatitude = 0;
  double _currentLongitude = 0; 
  String? _currentAddress;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  double? _selectedLatitude;
  double? _selectedLongitude;
  String address=''; 
  List<LatLng> _polylineCoordinates = [];

  LatLng? get currentLocation => _currentLocation;
  LatLng? get selectedLocation => _selectedLocation;
  String? get currentAddress => _currentAddress;
  double get currentLatitude => _currentLatitude;
  double get currentLongitude => _currentLongitude; 
  String? get selectedAddress => _selectedAddress;
  double? get selectedLatitude => _selectedLatitude;
  double? get selectedLongitude => _selectedLongitude;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  set selectedAddress(String? value) {
    _selectedAddress = value;
    notifyListeners();
  }

  set selectedLatitude(double? value) {
    _selectedLatitude = value;
    notifyListeners();
  }

  set selectedLongitude(double? value) {
    _selectedLongitude = value;
    notifyListeners();
  }

  set currentAddress(String? value) {
    _currentAddress = value;
    notifyListeners(); 
  }

  set currentLatitude(double value) {
    _currentLatitude = value;
    notifyListeners(); 
  }

  set currentLongitude(double value) {
    _currentLongitude = value;
    notifyListeners(); 
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          log("Location permission permanently denied.");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      _currentLatitude = position.latitude; // Store latitude
      _currentLongitude = position.longitude; // Store longitude
      _currentAddress = await getAddressFromCoordinates(position.latitude, position.longitude);
      log('ADDRESSSSSS $currentAddress');

      notifyListeners();
    } catch (e) {
      log("Error fetching location: $e");
    }
  }

  void setSelectedLocation(LatLng location, String address) {
    log("setSelectedLocation called with location: $location, address: $address");
    _selectedLocation = location;
    _selectedAddress = address;
    notifyListeners();
    fetchRoutePolyline();
  }

  // Function to fetch address from coordinates
  Future<String?> getAddressFromCoordinates(double latit, double longit) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latit, longit);
    address =
        "${placemarks[0].thoroughfare} ${placemarks[0].subLocality} ${placemarks[0].locality} ${placemarks[0].postalCode} ${placemarks[0].country}";
    log('ADDRESS VARIABLEE $address');
    notifyListeners();
    return address;
  }
  Future<void> fetchRoutePolyline() async {
    if (_currentLocation == null || _selectedLocation == null) return;

    String apiKey = "AIzaSyBzDnudfbtQegKHsECZ2ND-NQofYECKPzo";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${_selectedLocation!.latitude},${_selectedLocation!.longitude}&mode=driving&key=$apiKey";
        log(url);

    final response = await http.get(Uri.parse(url));
    final data=jsonDecode(response.body);
    log("Google Maps API Response: $data");

    if (data['status'] == 'OK') {
      String polyline = data['routes'][0]['overview_polyline']['points'];
      _polylineCoordinates = _decodePolyline(polyline);
      notifyListeners();
    } else {
      log("Failed to fetch route: ${data['status']}");
    }
  }
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}