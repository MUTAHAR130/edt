import 'dart:developer';

import 'package:edt/pages/driver_home/provider/accepted_provider.dart';
import 'package:edt/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

void getDriverDetailsSheet(BuildContext context) {
  showModalBottomSheet(
    // isDismissible: false,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Consumer<DriverDetailsProvider>(
            builder: (context, provider, child) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.42,
                ),
                child: Container(
                  height: getHeight(context) * 0.42,
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
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200]),
                              child: Center(
                                child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Davidson Edgar',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xff000000)),
                                ),
                                Text(
                                  '20 Journey',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Color(0xff4f4f4f)),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      5,
                                      (index) => SvgPicture.asset(
                                            'assets/icons/star.svg',
                                            width: 10,
                                            height: 10,
                                          )),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fee:',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xff545454)),
                                ),
                                Text(
                                  '\$150',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xff1D3557)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: getWidth(context) * 0.9,
                        child: Text(
                          'Receipient contact number',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xff77869e)),
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: getWidth(context) * 0.9,
                        child: Text(
                          '08123456789',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xff111111)),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Column(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff0F69DB)),
                                ),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff0F69DB)),
                                ),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff0F69DB)),
                                ),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Color(0xff0F69DB), width: 2)),
                                ),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffC4C4C4)),
                                ),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffC4C4C4)),
                                ),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Color(0xff87b4ed), width: 2)),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pickup Location',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xff77869e)),
                                ),
                                Text(
                                  '32 Samwell Sq, Chevron',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xff111111)),
                                ),
                                Text(
                                  'Drop off Location',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xff77869e)),
                                ),
                                Text(
                                  '21b, Karimu Kotun Street, Victoria Island',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xff111111)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          children: [
                            provider.isAccepted == false
                                ? Expanded(
                                    child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0xffFf3f7fd)),
                                      child: Center(
                                        child: Text(
                                          'Reject',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xff163051)),
                                        ),
                                      ),
                                    ),
                                  ))
                                : Container(
                                    height: 44,
                                    width: 46,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xffF163051)),
                                    child: Center(
                                        child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xffffffff),
                                    )),
                                  ),
                            provider.isAccepted == false
                                ? SizedBox(
                                    width: 16,
                                  )
                                : SizedBox(
                                    width: provider.goToA == false
                                        ? 66
                                        : provider.goToB == false && provider.isArrived==true
                                            ? 66
                                            : 22,
                                  ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                provider.isAccepted == false
                                    ? provider.toggleAccepted()
                                    : provider.goToA == false
                                        ? provider.toggleGoToA()
                                        : provider.isArrived == false
                                            ? provider.toggleArrive()
                                            : provider.goToB == false
                                                ? provider.toggleGoToB()
                                                : log('done');
                              },
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xffF163051)),
                                child: Center(
                                  child: Text(
                                    provider.isAccepted == false
                                        ? 'Accept'
                                        : provider.goToA == false
                                            ? 'Go to A'
                                            : provider.isArrived == false
                                                ? 'Arrive'
                                                : provider.goToB == false
                                                    ? 'Go to B'
                                                    : 'Finish',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xffffffff)),
                                  ),
                                ),
                              ),
                            )),



                            // provider.isArrived == false
                            //     ? SizedBox(
                            //         width: 20,
                            //       )
                            //     : provider.isFinished == false
                            //         ? SizedBox(
                            //             width: 22,
                            //           )
                            //         : SizedBox.shrink(),
                            // if (provider.isAccepted == false && provider.goToA==false && provider.isArrived==true ) ...[
                            //   SizedBox.shrink()
                            // ] else ...[
                            //   Container(
                            //       height: 44,
                            //       width: 46,
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(10),
                            //           color: Color(0xffF163051)),
                            //       child: Center(
                            //           child: SvgPicture.asset(
                            //         'assets/icons/loc_to.svg',
                            //         color: Colors.white,
                            //       ))),
                            // ],



                            //  SizedBox.shrink(),
                            // if (provider.isArrived == true &&
                            //     provider.isFinished == false && ) ...[
                            //   SizedBox.shrink()
                            // ] else ...[
                            //   Container(
                            //       height: 44,
                            //       width: 46,
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(10),
                            //           color: Color(0xffF163051)),
                            //       child: Center(
                            //           child: SvgPicture.asset(
                            //         'assets/icons/loc_to.svg',
                            //         color: Colors.white,
                            //       )))
                            // ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      });
    },
  );
}

class TipSelectionWidget extends StatefulWidget {
  @override
  _TipSelectionWidgetState createState() => _TipSelectionWidgetState();
}

class _TipSelectionWidgetState extends State<TipSelectionWidget> {
  int _selectedIndex = 0;

  List<String> tips = ['1', '2', '5', '10', '20'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tips.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color:
                      _selectedIndex == index ? Colors.blue : Color(0xffdddddd),
                ),
              ),
              child: Center(
                child: Text(
                  '\$${tips[index]}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff5a5a5a),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
