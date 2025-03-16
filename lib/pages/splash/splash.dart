import 'package:edt/pages/boarding/boarding.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showFirstLogo = true;

  void showPermissionDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Enable Notifications"),
          content: Text("Please enable notifications to receive updates."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Later"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: Text("Settings"),
            ),
          ],
        ),
      );
    });
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      PermissionStatus newStatus = await Permission.notification.request();
      if (newStatus.isDenied) {
        showPermissionDialog();
      }
    } else if (status.isPermanentlyDenied) {
      showPermissionDialog();
    }
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        showFirstLogo = false;
      });
    });

    Timer(const Duration(seconds: 5), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoarding()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F69DB),
              Color(0xFF163051),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: getWidth(context) * 0.5,
                      child: Image.asset('assets/images/car.png'),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: showFirstLogo
                        ? SizedBox(
                            key: ValueKey('text1'),
                            height: 100,
                            child: Text(
                              'EDT',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredoka(
                                  fontSize: 76,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffffffff)),
                            ),
                          )
                        : SizedBox(
                            key: ValueKey('text2'),
                            height: 100,
                            child: Text('Elderly & Disabled\nTransportations',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffffffff))),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
