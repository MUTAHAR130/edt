import 'package:edt/pages/home/widgets/cancel_ride.dart';
import 'package:edt/pages/home/widgets/sheet_text_field.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

void bottomSheet(BuildContext context) {
  showModalBottomSheet(
    // isDismissible: false,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      final List<String> _locations = [
        'Office',
        'Home',
        'Gym',
        'Park',
      ];
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Container(
              height: getHeight(context) * 0.6,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
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
                  Text('Select Address',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2a2a2a))),
                  SizedBox(height: 15),
                  Divider(
                    color: Color(0xffdddddd),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SheetTextField(
                      hintText: 'From',
                      imagePath: 'assets/icons/loc_from.svg',
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SheetTextField(
                      hintText: 'To',
                      imagePath: 'assets/icons/loc_to.svg',
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(
                    color: Color(0xffdddddd),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      width: getWidth(context) * 0.9,
                      child: Text('Recent PLaces',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff5a5a5a)))),
                  SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _locations.length,
                      itemBuilder: (context, index) {
                        return IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset('assets/icons/clock.svg'),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _locations[index],
                                        style: GoogleFonts.poppins(
                                          color: Color(0xff5a5a5a),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '2972 Westheimer Rd. Santa Ana, Illinois 854',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xffb8b8b8),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '2.7 km',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xff5a5a5a),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        cancelRideSheet(context);
                      },
                      child: getContainer(context, 'Confirm Location')),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
