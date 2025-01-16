import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      GestureDetector(
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
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Notifications',
                            style: GoogleFonts.poppins(
                              color: Color(0xff2a2a2a),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Today',
                  style: GoogleFonts.poppins(
                    color: Color(0xff2a2a2a),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffffffff)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff163051)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/payment.svg'),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Payment Successfully!',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xff121212),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Lorem ipsum dolor sit amet consectetur. Ultrici es tincidunt eleifend vitae',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xff898989),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    softWrap:true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                                    ),
                  );
                },)
                // IntrinsicHeight(
                //   child: Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: Color(0xffffffff)),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 15.0, vertical: 10),
                //       child: Row(
                //         children: [
                //           Container(
                //             width: 50,
                //             height: 50,
                //             decoration: BoxDecoration(
                //                 shape: BoxShape.circle,
                //                 color: Color(0xff163051)),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 SvgPicture.asset('assets/icons/payment.svg'),
                //               ],
                //             ),
                //           ),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Expanded(
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   'Payment Successfully!',
                //                   style: GoogleFonts.poppins(
                //                     color: Color(0xff121212),
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.w600,
                //                   ),
                //                 ),
                //                 Text(
                //                   'Lorem ipsum dolor sit amet consectetur. Ultrici es tincidunt eleifend vitae',
                //                   style: GoogleFonts.poppins(
                //                     color: Color(0xff898989),
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.w400,
                //                   ),
                //                   softWrap:true,
                //                   overflow: TextOverflow.visible,
                //                 ),
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
