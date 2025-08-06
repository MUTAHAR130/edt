import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/pages/home/widgets/payment_success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:edt/services/notifications_service.dart';

class RideDetailsScreen extends StatefulWidget {
  final String rideId;

  const RideDetailsScreen({Key? key, required this.rideId}) : super(key: key);

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  GoogleMapController? _mapController;
  Timer? locationUpdateTimer;

  final ValueNotifier<bool> _rideAcceptedNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<Set<Polyline>> _polylinesNotifier =
      ValueNotifier<Set<Polyline>>({});
  final ValueNotifier<bool> _showRouteNotifier = ValueNotifier<bool>(false);

  LatLng? _currentDriverLocation;
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  Set<Marker> _markers = {};
  bool _lastArrivedStatus = false;
  bool _lastCompletedStatus = false;
  String _lastPaymentStatus = '';
  Set<String> _notifiedPaymentIds = {};
  DateTime _sessionStartTime = DateTime.now();

  final double _ratePerKm = 1.0;

  final ValueNotifier<String> _buttonStateNotifier = ValueNotifier<String>("");

  Future<void> _storeRideHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userRoleProvider =
          Provider.of<UserRoleProvider>(context, listen: false);

      final String role = userRoleProvider.role;

      final driverDoc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(user.uid)
          .get();

      final vehicleName = driverDoc.data()?['vehicleName'] ?? 'Unknown Vehicle';

      final driverRef =
          FirebaseFirestore.instance.collection('drivers').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(driverRef);

        if (snapshot.exists) {

          final data = snapshot.data();

          if (data != null && data.containsKey('totalDeliveries')) {
            int currentTotal = data['totalDeliveries'] ?? 0;
            transaction
                .update(driverRef, {'totalDeliveries': currentTotal + 1});
          } else {
            transaction.update(driverRef, {'totalDeliveries': 1});
          }
          
        }
      });

      final rideDoc = await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .get();

      final price = rideDoc.data()?['price'] ?? 0.0;
      final roundedPrice = double.parse(price.toStringAsFixed(2));
      final passengerUid = rideDoc['passengerUid'] ?? '';

      await FirebaseFirestore.instance.collection('history').add({
        'driverUid': user.uid,
        'passengerUid': passengerUid,
        'rideId': widget.rideId,
        'price': roundedPrice,
        'role': role,
        'status': 'completed',
        'vehicleName': vehicleName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error storing ride history: $e');
    }
  }

  Future<void> acceptRide(String rideId) async {
    final driverUid = FirebaseAuth.instance.currentUser?.uid;
    if (driverUid == null) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied');
      return;
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      _currentDriverLocation = LatLng(position.latitude, position.longitude);

      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverUid)
          .update({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      await FirebaseFirestore.instance.collection('rides').doc(rideId).update({
        'driverFound': true,
        'driverId': driverUid,
      });

      _rideAcceptedNotifier.value = true;
      _buttonStateNotifier.value = "goToA";

      startLocationUpdates();
    } catch (e) {
      print('Error accepting ride: $e');
    }
  }

  Future<String?> getPassengerImage(String? passengerUid) async {
    if (passengerUid == null) return null;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('passengers')
          .doc(passengerUid)
          .get();
      return snapshot['passengerImage'];
    } catch (e) {
      print('Error fetching passenger image: $e');
      return null;
    }
  }

  void startLocationUpdates() {
    locationUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final driverUid = FirebaseAuth.instance.currentUser?.uid;
      if (driverUid == null) return;
      try {
        Position position = await Geolocator.getCurrentPosition();
        _currentDriverLocation = LatLng(position.latitude, position.longitude);
        await FirebaseFirestore.instance
            .collection('drivers')
            .doc(driverUid)
            .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      } catch (e) {
        print('Error updating location: $e');
      }
    });
  }

  Future<void> fetchAndDisplayRoute() async {
    if (_currentDriverLocation == null || _pickupLocation == null) return;
    String apiKey = "AIzaSyA5FXRZK0k8h8FeV8UPB1D7mUBfPzulFcs";
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentDriverLocation!.latitude},${_currentDriverLocation!.longitude}"
        "&destination=${_pickupLocation!.latitude},${_pickupLocation!.longitude}"
        "&mode=driving"
        "&key=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        String encodedPoints = data['routes'][0]['overview_polyline']['points'];
        List<LatLng> polylineCoordinates = _decodePolyline(encodedPoints);

        _polylinesNotifier.value = {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.red,
            width: 5,
          ),
        };
        _showRouteNotifier.value = true;
        if (_mapController != null) {
          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(
              min(_currentDriverLocation!.latitude, _pickupLocation!.latitude),
              min(_currentDriverLocation!.longitude,
                  _pickupLocation!.longitude),
            ),
            northeast: LatLng(
              max(_currentDriverLocation!.latitude, _pickupLocation!.latitude),
              max(_currentDriverLocation!.longitude,
                  _pickupLocation!.longitude),
            ),
          );
          _mapController!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
        }
      } else {
        print("Error from Directions API: ${data['status']}");
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  Future<void> fetchAndDisplayRouteToDestination() async {
    if (_destinationLocation == null) return;
    try {
      Position position = await Geolocator.getCurrentPosition();
      _currentDriverLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting current position: $e");
      return;
    }
    await Future.delayed(Duration(milliseconds: 300));

    String apiKey = "AIzaSyA5FXRZK0k8h8FeV8UPB1D7mUBfPzulFcs";
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentDriverLocation!.latitude},${_currentDriverLocation!.longitude}"
        "&destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}"
        "&mode=driving"
        "&key=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        String encodedPoints = data['routes'][0]['overview_polyline']['points'];
        List<LatLng> polylineCoordinates = _decodePolyline(encodedPoints);
        _polylinesNotifier.value = {
          Polyline(
            polylineId: PolylineId("routeToDestination"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        };
        _showRouteNotifier.value = true;
        if (_destinationLocation != null) {
          _markers.removeWhere((m) => m.markerId.value == 'destination');
          _markers.add(
            Marker(
              markerId: MarkerId('destination'),
              position: _destinationLocation!,
              infoWindow: InfoWindow(title: "Destination"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            ),
          );
        }
        if (_mapController != null) {
          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(
              min(_currentDriverLocation!.latitude,
                  _destinationLocation!.latitude),
              min(_currentDriverLocation!.longitude,
                  _destinationLocation!.longitude),
            ),
            northeast: LatLng(
              max(_currentDriverLocation!.latitude,
                  _destinationLocation!.latitude),
              max(_currentDriverLocation!.longitude,
                  _destinationLocation!.longitude),
            ),
          );
          _mapController!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
        }
      } else {
        print("Error from Directions API: ${data['status']}");
      }
    } catch (e) {
      print("Error fetching route to destination: $e");
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

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371;
    double dLat = _toRadians(end.latitude - start.latitude);
    double dLng = _toRadians(end.longitude - start.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(start.latitude)) *
            cos(_toRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  String computePrice() {
    if (_pickupLocation == null || _destinationLocation == null) return "\$0";
    double distance =
        calculateDistance(_pickupLocation!, _destinationLocation!);
    double price = distance * _ratePerKm;
    FirebaseFirestore.instance.collection('rides').doc(widget.rideId).update({
      'price': price,
    });
    return "\$${price.toStringAsFixed(2)}";
  }

  Future<void> rejectRide() async {
    try {
      await _storeRejectedRide();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBar(),
        ),
      );
    } catch (e) {
      print('Error rejecting ride: $e');
    }
  }

  Future<void> _storeRejectedRide() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userRoleProvider =
          Provider.of<UserRoleProvider>(context, listen: false);
      final String role = userRoleProvider.role;

      final driverDoc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(user.uid)
          .get();

      final vehicleName = driverDoc.data()?['vehicleName'] ?? 'Unknown Vehicle';

      final rideDoc = await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .get();

      final passengerUid = rideDoc.data()?['passengerUid'] ?? '';

      await FirebaseFirestore.instance.collection('history').add({
        'driverUid': user.uid,
        'passengerUid': passengerUid,
        'rideId': widget.rideId,
        'price': 0.0,
        'role': role,
        'status': 'cancelled',
        'vehicleName': vehicleName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .update({
        'rejectedDrivers': FieldValue.arrayUnion([user.uid]),
        'lastRejectedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error storing rejected ride: $e');
    }
  }

  void _setupRideListener() {
    final String driverUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (driverUid.isEmpty) return;

    // Listen for ride status changes
    FirebaseFirestore.instance
        .collection('rides')
        .doc(widget.rideId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final bool arrived = data['arrived'] ?? false;
      final bool completed = data['status'] == 'completed';
      final double price = data['price'] ?? 0.0;

      // Show local notification when status changes
      if (arrived && _lastArrivedStatus == false) {
        NotificationService.showLocalNotification(
          'You have arrived at pickup location',
          'Your passenger is waiting for you.',
        );
        _lastArrivedStatus = arrived;
      }

      if (completed && _lastCompletedStatus == false) {
        NotificationService.showLocalNotification(
          'Ride Completed',
          'You have earned \$${price.toStringAsFixed(2)} from this ride.',
        );
        _lastCompletedStatus = completed;
      }
    });

    // Listen for payments with timestamp filter
    FirebaseFirestore.instance
        .collection('payments')
        .where('driverId', isEqualTo: driverUid)
        .where('rideId', isEqualTo: widget.rideId)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        // Only process documents that were added or modified
        if (change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) {
          final data = change.doc.data() as Map<String, dynamic>;

          // Check if this payment update happened after we opened this screen
          final Timestamp paymentTimestamp = data['timestamp'] as Timestamp? ??
              Timestamp.fromDate(DateTime(2000)); // Default old date if null

          // Only process if the payment was created/updated after this screen was opened
          if (paymentTimestamp.toDate().isAfter(_sessionStartTime)) {
            final String paymentId = change.doc.id;
            final String status = data['status'] ?? '';
            final String amount = data['amount'] ?? '0.00';
            final String notificationKey = '$paymentId:$status';

            if (!_notifiedPaymentIds.contains(notificationKey)) {
              if (status == 'Completed') {
                NotificationService.showLocalNotification(
                  'Payment Received',
                  'You received a payment of \$$amount from your passenger.',
                );
                _notifiedPaymentIds.add(notificationKey);
              } else if (status == 'Cancelled') {
                NotificationService.showLocalNotification(
                  'Payment Cancelled',
                  'Payment of \$$amount from your passenger was cancelled or failed.',
                );
                _notifiedPaymentIds.add(notificationKey);
              }
            }
          }
        }
      }
    });
  }

  void _setupForegroundNotificationHandling() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        NotificationService.showLocalNotification(
            message.notification?.title, message.notification?.body);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sessionStartTime = DateTime.now(); // Remember when we opened this screen
    NotificationService.init();
    _setupForegroundNotificationHandling();
    _setupRideListener();
  }

  @override
  void dispose() {
    locationUpdateTimer?.cancel();
    _mapController?.dispose();
    _buttonStateNotifier.dispose();
    _rideAcceptedNotifier.dispose();
    _polylinesNotifier.dispose();
    _showRouteNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rides')
              .doc(widget.rideId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data?.data() as Map<String, dynamic>?;
            if (data == null) {
              return Center(child: Text('Ride not found'));
            }

            if (data['passengerLatitude'] != null &&
                data['passengerLongitude'] != null) {
              _pickupLocation = LatLng(
                data['passengerLatitude'],
                data['passengerLongitude'],
              );
              _markers.removeWhere((m) => m.markerId.value == 'pickup');
              _markers.add(
                Marker(
                  markerId: MarkerId('pickup'),
                  position: _pickupLocation!,
                  infoWindow: InfoWindow(title: "Pickup Location"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              );
            }

            if (data['destinationLatitude'] != null &&
                data['destinationLongitude'] != null) {
              _destinationLocation = LatLng(
                data['destinationLatitude'],
                data['destinationLongitude'],
              );
              _markers.removeWhere((m) => m.markerId.value == 'destination');
              _markers.add(
                Marker(
                  markerId: MarkerId('destination'),
                  position: _destinationLocation!,
                  infoWindow: InfoWindow(title: "Destination"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _showRouteNotifier,
                    builder: (context, showRoute, child) {
                      return ValueListenableBuilder<Set<Polyline>>(
                        valueListenable: _polylinesNotifier,
                        builder: (context, polylines, child) {
                          return GoogleMap(
                            key: ValueKey(polylines.hashCode),
                            initialCameraPosition: CameraPosition(
                              target: _pickupLocation ??
                                  LatLng(30.1839768, 71.5113495),
                              zoom: 14,
                            ),
                            markers: _markers,
                            polylines: showRoute ? polylines : {},
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                          );
                        },
                      );
                    },
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: FutureBuilder<String?>(
                                future: getPassengerImage(data['passengerUid']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  final imageUrl = snapshot.data;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: imageUrl != null &&
                                            imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(Icons.person),
                                          )
                                        : Icon(Icons.person),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['passengerName'] ??
                                        'Name not available',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Text(
                                    data['passengerPhone'] ??
                                        'Phone not available',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0xff4f4f4f),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Fee:',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xff545454),
                                  ),
                                ),
                                Text(
                                  computePrice(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff1D3557),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            _buildLocationIndicator(),
                            SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLocationText(
                                    'Pickup Location',
                                    data['passengerAddress'] ??
                                        'Address not available',
                                  ),
                                  SizedBox(height: 14),
                                  _buildLocationText(
                                    'Drop off Location',
                                    data['destinationAddress'] ??
                                        'Destination not available',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        ValueListenableBuilder<bool>(
                          valueListenable: _rideAcceptedNotifier,
                          builder: (context, rideAccepted, child) {
                            if (rideAccepted) {
                              return ValueListenableBuilder<String>(
                                valueListenable: _buttonStateNotifier,
                                builder: (context, buttonState, child) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (buttonState == "goToA") {
                                          await fetchAndDisplayRoute();
                                          _buttonStateNotifier.value =
                                              "arrived";
                                        } else if (buttonState == "arrived") {
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          // print('UER ISS ${user!.uid}');
                                          if (user != null) {
                                            await FirebaseFirestore.instance
                                                .collection('rides')
                                                .doc(widget.rideId)
                                                .update({'arrived': true});
                                          }
                                          _buttonStateNotifier.value = "goToB";
                                        } else if (buttonState == "goToB") {
                                          await fetchAndDisplayRouteToDestination();
                                          _buttonStateNotifier.value = "Finish";
                                        } else if (buttonState == "Finish") {
                                          await _storeRideHistory();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BottomBar(),
                                            ),
                                          );
                                          // showPaymentSuccess(context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff163051),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        buttonState == "goToA"
                                            ? "Go to A"
                                            : buttonState == "arrived"
                                                ? "Arrived"
                                                : buttonState == "goToB"
                                                    ? "Go to B"
                                                    : "Finish",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        rejectRide();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xffF3f7fd),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        'Reject',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(0xff163051),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        acceptRide(widget.rideId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff163051),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        'Accept',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper widget: Location indicator.
  Widget _buildLocationIndicator() {
    return Column(
      spacing: 12,
      children: [
        Icon(Icons.location_on, color: Colors.red, size: 20),
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff0F69DB),
              ),
            ),
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xff0F69DB), width: 2),
          ),
        ),
      ],
    );
  }

  // Helper widget: Display location text.
  Widget _buildLocationText(String title, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff77869e),
          ),
        ),
        SizedBox(height: 4),
        Text(
          address,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff111111),
          ),
        ),
      ],
    );
  }
}
