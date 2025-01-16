import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

Widget getRideContainer(context) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xff0F69DB),
          // : Color(0xff80afec),
          width: 1.5,
        ),
        color: Color(0xffcfe1f8)
        // : Color(0xfff3f7fd),
        ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mustang Shelby GT',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Color(0xff5a5a5a),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/star.svg'),
                        ],
                      ),
                      Text('4.9 (531 reviews)',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffa0a0a0))),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 95,
              height: 55,
              child: SvgPicture.asset(
                'assets/images/mustang.jpg',
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
