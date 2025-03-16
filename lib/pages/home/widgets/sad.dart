import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

void sadDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: SizedBox(
              width: getWidth(context) * 0.85,
              child: Column(
                children: [
                  SizedBox(height: 24,),
                  SvgPicture.asset('assets/icons/sad.svg'),
                  SizedBox(height: 24,),
                  Text(
                    'Were so sad\nabout your cancellation',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff2a2a2a)),
                  ),
                  SizedBox(height: 7,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'We will continue to improve our service & satify you on the next trip.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff898989)),
                    ),
                  ),
                  SizedBox(height: 32,),
                  Padding(
                    padding: const EdgeInsets.only(left: 11,right: 11,bottom: 24),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => BottomBar()),
                          (Route<dynamic> route) => false, // Removes all previous routes
                        );
                      },
                      child: getContainer(context, 'Back Home')),
                  )
                ],
              )),
        ),
      );
    },
  );
}
