import 'package:edt/pages/authentication/enable_location/welcome.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnableLocation extends StatelessWidget {
  const EnableLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/map.png')),
          Positioned.fill(
              child: Container(
            color: Colors.black.withOpacity(0.4),
          )),
          Center(
            child: IntrinsicHeight(
              child: Container(
                width: getWidth(context) * 0.85,
                // height: 460,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                            width: 144,
                            height: 144,
                            child: Image.asset('assets/images/mapIcon.png')),
                            SizedBox(height: 17,),
                        Text(
                          'Enable your location',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Color(0xff2a2a2a),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Choose your location to start find the request around you',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Color(0xffa0a0a0),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 40),
                        getContainer(context, 'Use my location'),
                        SizedBox(height: 35,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
                          },
                          child: Text('Skip for now',style: GoogleFonts.poppins(
                              color: Color(0xffb8b8b8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
