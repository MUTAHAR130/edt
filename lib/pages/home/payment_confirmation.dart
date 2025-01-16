import 'package:edt/pages/home/widgets/payment_success.dart';
import 'package:edt/pages/home/widgets/payment_method.dart';
import 'package:edt/pages/home/widgets/ride_container.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentConfirmation extends StatefulWidget {
  const PaymentConfirmation({super.key});

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  String selectedOption = 'Visa';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          'Payment',
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
              getRideContainer(context),
              SizedBox(
                height: 17,
              ),
              Text(
                'Charges',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff5a5a5a)),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Mustang/',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5a5a5a)),
                      ),
                      Text(
                        'per hours',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5a5a5a)),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '\$200',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5a5a5a)),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Vat ',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5a5a5a)),
                      ),
                      Text(
                        '(5%)',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5a5a5a)),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '\$20',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5a5a5a)),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Promo Code',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5a5a5a)),
                  ),
                  Spacer(),
                  Text(
                    '-\$5',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5a5a5a)),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5a5a5a)),
                  ),
                  Spacer(),
                  Text(
                    '\$215',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5a5a5a)),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Text(
                    'Select payment method',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5a5a5a)),
                  ),
                  Spacer(),
                  Text(
                    'View All ',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0F69DB)),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              PaymentMethod(
                  iconPath: 'assets/icons/visa.svg',
                  title: '**** **** **** 8970',
                  subtitle: 'Expires: 12/26',
                  isSelected: selectedOption == 'Visa',
                  onTap: () {
                    setState(() => selectedOption = 'Visa');
                  }),
              SizedBox(
                height: 10,
              ),
              PaymentMethod(
                  iconPath: 'assets/icons/mastercard.svg',
                  title: '**** **** **** 8970',
                  subtitle: 'Expires: 12/26',
                  isSelected: selectedOption == 'Mastercard',
                  onTap: () {
                    setState(() => selectedOption = 'Mastercard');
                  }),
              SizedBox(
                height: 10,
              ),
              PaymentMethod(
                  iconPath: 'assets/icons/payonner.svg',
                  title: '**** **** **** 8970',
                  subtitle: 'Expires: 12/26',
                  isSelected: selectedOption == 'Payonner',
                  onTap: () {
                    setState(() => selectedOption = 'Payonner');
                  }),
              SizedBox(
                height: 10,
              ),
              PaymentMethod(
                  iconPath: 'assets/icons/cash.svg',
                  title: '**** **** **** 8970',
                  subtitle: 'Expires: 12/26',
                  isSelected: selectedOption == 'Cash',
                  onTap: () {
                    setState(() => selectedOption = 'Cash');
                  }),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                  onTap: () {
                    showPaymentSuccess(context);
                  },
                  child: getContainer(context, 'Confirm Ride'))
            ],
          ),
        )),
      ),
    );
  }
}
