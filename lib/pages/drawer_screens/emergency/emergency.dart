import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

void emergencySheet(BuildContext context) {
  showModalBottomSheet(
    // isDismissible: false,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.46,
            ),
            child: Container(
              height: getHeight(context) * 0.46,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130.0),
                      child: Divider(
                        thickness: 3,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Emergency Assist',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff2a2a2a))),
                    SizedBox(height: 12),
                    Text('Share your location and car detail to operator.',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffa0a0a0))),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset('assets/icons/loc_to.svg'),
                          ],
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Text(
                              '2972 Westheimer Rd. Santa Ana, Illinois 85486',
                              softWrap: true,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff5a5a5a))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset('assets/icons/car.svg'),
                          ],
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Text(
                              'Toyota Corolla, Grey, No 0129',
                              softWrap: true,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff5a5a5a))),
                        )
                      ],
                    ),
                    SizedBox(height: 55,),
                    getContainer(context, 'Call 911')
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
