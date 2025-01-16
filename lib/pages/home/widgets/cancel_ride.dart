import 'package:edt/pages/home/payment_confirmation.dart';
import 'package:edt/pages/home/reason_cancel.dart';
import 'package:edt/pages/home/widgets/payment_method.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

void cancelRideSheet(BuildContext context) {
  showModalBottomSheet(
    // isDismissible: false,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      String selectedOption = 'Visa';
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Container(
                height: getHeight(context) * 0.5,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                      child: Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 130.0),
                            child: Divider(
                              thickness: 3,
                            ),
                          ),
                          Positioned(
                            right: 20,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xff5A5A5A),
                                  size: 19,
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: getWidth(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text('Your driver is coming in 3:35',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff5a5a5a))),
                      ),
                    ),
                    SizedBox(height: 30),
                    IntrinsicHeight(
                      child: Container(
                        width: getWidth(context),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 55,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/user.png'))),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Text('User',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff2a2a2a))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/icons/ride_loc.svg'),
                                          ],
                                        ),
                                        Text('800m (5mins away)',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xffa0a0a0))),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/icons/star.svg'),
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
                    SizedBox(height: 15),
                    Divider(
                      color: Color(0xffdddddd),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                        width: getWidth(context) * 0.9,
                        child: Row(
                          children: [
                            Text('Payment method',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff5a5a5a))),
                            Spacer(),
                            Text('\$220.00',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff2a2a2a))),
                          ],
                        )),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: PaymentMethod(
                          iconPath: 'assets/icons/visa.svg',
                          title: '**** **** **** 8970',
                          subtitle: 'Expires: 12/26',
                          isSelected: selectedOption == 'Visa',
                          onTap: () {
                            setState(() => selectedOption = 'Visa');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentConfirmation()));
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CancelReason(context: context,)));
                            },
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xffBD0A00)),
                              child: Center(
                                  child: Text(
                                'Cancel Ride',
                                style: GoogleFonts.poppins(
                                  color: Color(0xffffffff),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            )))
                  ],
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
