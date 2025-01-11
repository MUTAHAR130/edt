import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getContainer(context, String text) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), color: Color(0xff163051)),
    child: Center(
        child: Text(
      text,
      style: GoogleFonts.poppins(
        color: Color(0xffffffff),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    )),
  );
}
