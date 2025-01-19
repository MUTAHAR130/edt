import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar getBackButton(context) {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 0,
    primary: true,
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    title: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Color(0xff414141),
          ),
          Text(
            'Back',
            style: GoogleFonts.poppins(
              color: Color(0xff414141),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
