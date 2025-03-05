import 'dart:developer';
import 'package:edt/main.dart';
import 'package:edt/pages/home/widgets/dotted_divider.dart';
import 'package:edt/pages/home/widgets/feedback_sheet.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

void showPaymentSuccess(String price) {
  final BuildContext? context = 
      navigatorKey.currentState?.overlay?.context;
  
  if (context == null) {
    print('Unable to show payment success dialog: No active context');
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
            width: getWidth(context) * 0.85,
            height: getHeight(context) * 0.61,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.
                      only(right: 15.0,top: 15),
                      child: Icon(
                        Icons.close,
                        color: Color(0xff5A5A5A),
                      ),
                    ),
                  ),
                ),
                SvgPicture.asset('assets/icons/payment_success.svg'),
                SizedBox(height: 20,),
                Text(
                  'Payment Success',
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff2a2a2a)),
                ),
                SizedBox(height: 7,),
                Text(
                  'Your money has been successfully sent!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff898989)),
                ),
                SizedBox(height: 24,),
                Text(
                  'Amount',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5a5a5a)),
                ),
                Text(
                  '\$$price',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2a2a2a)),
                ),
                SizedBox(height: 10,),
                DottedDivider(color: Color(0xffb8b8b8),),
                SizedBox(height: 30,),
                Text(
                  'How was your trip?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5a5a5a)),
                ),
                SizedBox(height: 8,),
                Text(
                  'Your feedback will help us to improve your driving experience better',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffa0a0a0)),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      getFeedbackSheet(context);
                    },
                    child: getContainer(context, 'Please Feedback')),
                )
              ],
            )),
      );
    },
  );
}