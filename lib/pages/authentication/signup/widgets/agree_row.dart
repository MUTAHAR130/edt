import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

Widget aggreeRow() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/check_circle.svg'),
        ],
      ),
      SizedBox(width: 5),
      Expanded(
          child: Text.rich(
        TextSpan(
          text: 'By submitting documents, you aggree to the ',
          style: GoogleFonts.poppins(
              color: Color(0xffB8B8B8),
              fontSize: 12,
              fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(
              text: 'Terms of Service',
              style: GoogleFonts.poppins(
                  color: Color(0xff163051),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            TextSpan(
              text: ' and ',
              style: GoogleFonts.poppins(
                  color: Color(0xffB8B8B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: GoogleFonts.poppins(
                  color: Color(0xff163051),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            TextSpan(
              text: '.',
            ),
          ],
        ),
      ))
    ],
  );
}
