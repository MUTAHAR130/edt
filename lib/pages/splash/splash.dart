import 'package:edt/pages/boarding/boarding.dart';
import 'package:edt/utils/helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showFirstLogo = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        showFirstLogo = false;
      });
    });

    Timer(const Duration(seconds: 5), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoarding()));
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
                            child: Text('EDT',textAlign: TextAlign.center,style: GoogleFonts.fredoka(
                              fontSize: 76,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffffffff)
                            ),),
                          )
                        : SizedBox(
                            key: ValueKey('text2'),
                            height: 100,
                            child: Text('Elderly & Disabled\nTransportations',textAlign: TextAlign.center,style: GoogleFonts.fredoka(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffffffff)
                            )),
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
