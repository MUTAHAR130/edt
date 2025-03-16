import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/home/payment_confirmation.dart';
import 'package:edt/pages/home/reason_cancel.dart';
import 'package:edt/pages/home/widgets/payment_method.dart';
import 'package:edt/services/paypal_service.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/pages/home/provider/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CancelRideContainer extends StatefulWidget {
  const CancelRideContainer({Key? key}) : super(key: key);

  @override
  _CancelRideContainerState createState() => _CancelRideContainerState();
}

class _CancelRideContainerState extends State<CancelRideContainer> {
  String selectedOption = 'Visa';
  final ValueNotifier<bool> _arrivedNotifier = ValueNotifier<bool>(false);
  StreamSubscription<DocumentSnapshot>? _rideStreamSubscription;
  String? vehicleName;
  String? driverUid;
  String? passengerUid;
  String? rideId;

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371;
    double dLat = (end.latitude - start.latitude) * pi / 180;
    double dLng = (end.longitude - start.longitude) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(start.latitude * pi / 180) *
            cos(end.latitude * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c * 1000;
  }

  Future<Map<String, dynamic>> fetchRideAndDriverData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};
    rideId = user.uid;
    
    DocumentSnapshot rideSnapshot = await FirebaseFirestore.instance
        .collection('rides')
        .doc(user.uid)
        .get();
    if (!rideSnapshot.exists) return {};
    final rideData = rideSnapshot.data() as Map<String, dynamic>;

    String driverId = rideData['driverId'] ?? '';
    driverUid = rideData['driverId'] ?? '';
    passengerUid = rideData['passengerUid'] ?? '';
    double price = 0.0;
    try {
      price = double.parse(rideData['price'].toString());
    } catch (e) {
      price = 0.0;
    }

    String driverName = 'Driver';
    double? driverLat;
    double? driverLng;
    String? driverImageUrl;
    if (driverId.isNotEmpty) {
      DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .get();
      if (driverSnapshot.exists) {
        final driverData = driverSnapshot.data() as Map<String, dynamic>;
        driverName = driverData['fullname'] ?? 'Driver';
        driverImageUrl = driverData['driverImage'] ?? '';
        vehicleName = driverData['vehicleName'] ?? 'Car';
        try {
          driverLat = double.parse(driverData['latitude'].toString());
          driverLng = double.parse(driverData['longitude'].toString());
        } catch (e) {
          driverLat = null;
          driverLng = null;
        }
      }
    }

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    double userLat = locationProvider.currentLatitude;
    double userLng = locationProvider.currentLongitude;
    double distance = 0;
    if (driverLat != null && driverLng != null) {
      distance = calculateDistance(
          LatLng(userLat, userLng), LatLng(driverLat, driverLng));
    }

    double passengerLat =
        double.tryParse(rideData['passengerLatitude'].toString()) ?? 0;
    double passengerLng =
        double.tryParse(rideData['passengerLongitude'].toString()) ?? 0;
    double destinationLat =
        double.tryParse(rideData['destinationLatitude'].toString()) ?? 0;
    double destinationLng =
        double.tryParse(rideData['destinationLongitude'].toString()) ?? 0;

    bool arrived = rideData['arrived'] ?? false;

    return {
      'driverName': driverName,
      'price': price,
      'distance': distance,
      'driverPic': driverImageUrl,
      'passengerLat': passengerLat,
      'passengerLng': passengerLng,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
      'arrived': arrived,
    };
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _rideStreamSubscription = FirebaseFirestore.instance
          .collection('rides')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          bool arrived = data['arrived'] ?? false;
          _arrivedNotifier.value = arrived;
          if (arrived) {
            // Optionally, update polyline on the map if needed.
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _rideStreamSubscription?.cancel();
    _arrivedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchRideAndDriverData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final fetchedData = snapshot.data!;
        String driverName = fetchedData['driverName'] ?? 'Driver';
        double price = fetchedData['price'] ?? 0.0;
        double distance = fetchedData['distance'] ?? 0.0;
        String driverPic = fetchedData['driverPic'] ?? '';
        String distanceText = "${distance.toStringAsFixed(0)} m";

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _arrivedNotifier,
                    builder: (context, arrived, child) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          arrived
                              ? 'Your Driver is Here'
                              : 'Your Driver is Coming',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff5a5a5a),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                IntrinsicHeight(
                  child: Container(
                    width: getWidth(context),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: driverPic.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    driverPic,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  driverName,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff2a2a2a),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/ride_loc.svg'),
                                    const SizedBox(width: 4),
                                    Text(
                                      distanceText,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xffa0a0a0),
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 4),
                                // // Rating row (to be implemented later).
                                // Row(
                                //   children: [
                                //     SvgPicture.asset('assets/icons/star.svg'),
                                //     const SizedBox(width: 4),
                                //     Text(
                                //       '4.9 (531 reviews)',
                                //       textAlign: TextAlign.left,
                                //       style: GoogleFonts.poppins(
                                //         fontSize: 10,
                                //         fontWeight: FontWeight.w400,
                                //         color: const Color(0xffa0a0a0),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(color: Color(0xffdddddd)),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        'Payment method',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff5a5a5a),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "\$${price.toStringAsFixed(2)}",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff2a2a2a),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PaymentMethod(
                    iconPath: 'assets/icons/payonner.svg',
                    title: '**** **** **** 8970',
                    subtitle: 'Pay with PayPal',
                    isSelected: selectedOption == 'Payonner',
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentConfirmation(
                            price: price.toStringAsFixed(2),
                            vehicleName: vehicleName,
                            driverUid:driverUid,
                            passengerUid:passengerUid,
                            rideId: rideId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CancelReason(
                            context: context,
                            rideId: rideId,
                            amount:price,
                            vehicleName: vehicleName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffBD0A00),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel Ride',
                          style: GoogleFonts.poppins(
                            color: const Color(0xffffffff),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}