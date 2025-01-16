import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getRow() {
  return Row(
    children: [
      Text(
        'Recent Places',
        style: GoogleFonts.poppins(
          color: Color(0xff5a5a5a),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      Spacer(),
      Text('Clear All',
          style: GoogleFonts.poppins(
            color: Color(0xff0F69DB),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
    ],
  );
}
