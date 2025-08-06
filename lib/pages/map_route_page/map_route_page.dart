import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/pages/home/home.dart';
import 'package:edt/pages/home/payment_confirmation.dart';
import 'package:edt/pages/home/provider/location_provider.dart';
import 'package:edt/pages/home/widgets/cancel_ride.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  StreamSubscription<DocumentSnapshot>? _rideSubscription;
  StreamSubscription<DocumentSnapshot>? _driverSubscription;

  bool driverFound = false;
  LatLng? driverLocation;

  final ValueNotifier<Set<Marker>> _markersNotifier =
      ValueNotifier<Set<Marker>>({});
  final ValueNotifier<Set<Polyline>> _polylinesNotifier =
      ValueNotifier<Set<Polyline>>({});

  @override
  void initState() {
    super.initState();
    saveData();
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    _listenToRideUpdates();
  }

  @override
  void dispose() {
    _rideSubscription?.cancel();
    _driverSubscription?.cancel();
    _markersNotifier.dispose();
    _polylinesNotifier.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? '';

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('passengers')
        .doc(uid)
        .get();

    String passengerName = snapshot.data()?['username'] ?? 'Anonymous';
    String passengerPhone = snapshot.data()?['phone'] ?? '';
    String passengerUid = snapshot.data()?['uid'] ?? '';

    var locPro = Provider.of<LocationProvider>(context, listen: false);

    await FirebaseFirestore.instance.collection('rides').doc(uid).set({
      'uid': uid,
      'passengerName': passengerName,
      'passengerUid': passengerUid,
      'passengerPhone': passengerPhone,
      'passengerAddress': locPro.currentAddress,
      'passengerLatitude': locPro.currentLatitude,
      'passengerLongitude': locPro.currentLongitude,
      'destinationAddress': locPro.selectedAddress,
      'destinationLatitude': locPro.selectedLatitude,
      'destinationLongitude': locPro.selectedLongitude,
      'driverFound': false,
      'driverId': '',
      'arrived': false,
    });
  }

  void _listenToRideUpdates() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    _rideSubscription = FirebaseFirestore.instance
        .collection('rides')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      dev.log(snapshot.data().toString());

      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;

      bool found = data['driverFound'] ?? false;

      setState(() {
        driverFound = found;
      });

      String driverId = data['driverId'] ?? '';

      if (found && driverId.isNotEmpty) {
        _listenToDriverLocation(driverId);
      }

      bool arrived = data['arrived'] ?? false;
      if (arrived) {
        if (data['status'] == 'completed') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
          );
          return;
        }

        _updateArrivalRoute();
      }
    });
  }

  void _listenToDriverLocation(String driverId) {
    _driverSubscription?.cancel();

    _driverSubscription = FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId)
        .snapshots()
        .listen((snapshot) {
      dev.log(snapshot.data().toString());
      if (!snapshot.exists) return;

      double? lat = snapshot.data()?['latitude'];
      double? lng = snapshot.data()?['longitude'];

      if (lat != null && lng != null) {
        driverLocation = LatLng(lat, lng);
        _updateDriverMarkersAndRoute();
      }
    });
  }

  Future<void> _updateDriverMarkersAndRoute() async {
    var locPro = Provider.of<LocationProvider>(context, listen: false);
    LatLng passengerLoc =
        LatLng(locPro.currentLatitude, locPro.currentLongitude);

    Set<Marker> markers = {
      Marker(
        markerId: MarkerId("passenger"),
        position: passengerLoc,
        infoWindow: InfoWindow(title: "Pickup Location"),
      ),
    };

    if (driverLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId("driver"),
          position: driverLocation!,
          infoWindow: InfoWindow(title: "Driver"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    _markersNotifier.value = markers;

    if (driverLocation != null) {
      String apiKey = "AIzaSyA5FXRZK0k8h8FeV8UPB1D7mUBfPzulFcs";
      final String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${driverLocation!.latitude},${driverLocation!.longitude}"
          "&destination=${passengerLoc.latitude},${passengerLoc.longitude}"
          "&mode=driving"
          "&key=$apiKey";
      try {
        final response = await http.get(Uri.parse(url));
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          String encodedPoints =
              data['routes'][0]['overview_polyline']['points'];
          List<LatLng> decodedPoints = _decodePolyline(encodedPoints);

          _polylinesNotifier.value = {
            Polyline(
              polylineId: PolylineId("driver_route"),
              points: decodedPoints,
              color: Colors.blue,
              width: 5,
            ),
          };

          if (_mapController != null) {
            LatLngBounds bounds = LatLngBounds(
              southwest: LatLng(
                min(passengerLoc.latitude, driverLocation!.latitude),
                min(passengerLoc.longitude, driverLocation!.longitude),
              ),
              northeast: LatLng(
                max(passengerLoc.latitude, driverLocation!.latitude),
                max(passengerLoc.longitude, driverLocation!.longitude),
              ),
            );

            _mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 100),
            );
          }
        } else {
          print("Error from Directions API: ${data['status']}");
        }
      } catch (e) {
        print("Error fetching driver route: $e");
      }
    }
  }

  Future<void> _updateArrivalRoute() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    DocumentSnapshot rideSnapshot = await FirebaseFirestore.instance
        .collection('rides')
        .doc(user.uid)
        .get();

    if (!rideSnapshot.exists) return;

    final rideData = rideSnapshot.data() as Map<String, dynamic>;

    double originLat = driverLocation?.latitude ?? 0;
    double originLng = driverLocation?.longitude ?? 0;

    double destinationLat =
        double.tryParse(rideData['destinationLatitude'].toString()) ?? 0;

    double destinationLng =
        double.tryParse(rideData['destinationLongitude'].toString()) ?? 0;

    String apiKey = "AIzaSyA5FXRZK0k8h8FeV8UPB1D7mUBfPzulFcs";

    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng"
        "&destination=$destinationLat,$destinationLng"
        "&mode=driving"
        "&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        String encodedPoints = data['routes'][0]['overview_polyline']['points'];

        List<LatLng> decodedPoints = _decodePolyline(encodedPoints);

        _polylinesNotifier.value = {
          Polyline(
            polylineId: PolylineId("arrival_route"),
            points: decodedPoints,
            color: Colors.green,
            width: 5,
          ),
        };

        Marker destinationMarker = Marker(
          markerId: MarkerId("destination"),
          position: LatLng(destinationLat, destinationLng),
          infoWindow: InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );

        Set<Marker> updatedMarkers = _markersNotifier.value;
        updatedMarkers.removeWhere((m) => m.markerId.value == "destination");
        updatedMarkers.add(destinationMarker);
        _markersNotifier.value = updatedMarkers;

        if (_mapController != null) {
          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(
              min(originLat, destinationLat),
              min(originLng, destinationLng),
            ),
            northeast: LatLng(
              max(originLat, destinationLat),
              max(originLng, destinationLng),
            ),
          );
          _mapController!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
        }
      } else {
        print("Error from Directions API (arrival): ${data['status']}");
      }
    } catch (e) {
      print("Error fetching arrival route: $e");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          if (locationProvider.currentLocation == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              // Expanded map widget.
              Expanded(
                child: Stack(
                  children: [
                    ValueListenableBuilder<Set<Marker>>(
                      valueListenable: _markersNotifier,
                      builder: (context, markers, child) {
                        return ValueListenableBuilder<Set<Polyline>>(
                          valueListenable: _polylinesNotifier,
                          builder: (context, polylines, child) {
                            return GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(locationProvider.currentLatitude,
                                    locationProvider.currentLongitude),
                                zoom: 14,
                              ),
                              onMapCreated: (controller) {
                                _mapController = controller;
                              },
                              markers: markers,
                              polylines: polylines,
                            );
                          },
                        );
                      },
                    ),
                    if (!driverFound)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text(
                                'Finding Driver...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Show the CancelRideContainer (which shows ride details) if a driver is found.
              if (driverFound) CancelRideContainer(),
            ],
          );
        },
      ),
    );
  }
}
