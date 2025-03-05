import 'package:edt/pages/notification/notification.dart';
import 'package:edt/pages/search_location/search_location.dart';
import 'package:edt/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:svg_flutter/svg.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScreen({super.key,required this.scaffoldKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(30.1864, 71.4886);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              compassEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              // myLocationButtonEnabled: true,
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        final scaffold = Scaffold.of(context);
                          if (scaffold.hasDrawer) {
                            scaffold.openDrawer();
                          } else {
                            widget.scaffoldKey.currentState?.openDrawer();
                          }
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xffe7f0fc).withOpacity(0.8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/bars.svg'),
                          ],
                        ),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                    },
                    child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xffe7f0fc).withOpacity(0.8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/notification.svg'),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 100,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchLocation()));
                  },
                  child: Container(
                    width: getWidth(context) * 0.9,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffe7f0fc),
                        border: Border.all(
                            color: Color.fromARGB(76, 15, 103, 219))),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        'assets/icons/search.svg',
                        color: Color(0xff0F69DB),
                      ),
                      title: Text(
                        'Where would you go?',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff0F69DB)),
                      ),
                      trailing: SvgPicture.asset('assets/icons/heart.svg'),
                    ),
                  ),
                ),
              ))
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 160.0),
      //   child: Container(
      //     width: 34,
      //     height: 34,
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(4), color: Color(0xffffffff)),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [SvgPicture.asset('assets/icons/location_button.svg')],
      //     ),
      //   ),
      // ),
    );
  }
}
