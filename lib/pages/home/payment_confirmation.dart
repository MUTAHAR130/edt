import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/home/widgets/payment_success.dart';
import 'package:edt/pages/home/widgets/payment_method.dart';
import 'package:edt/pages/home/widgets/ride_container.dart';
import 'package:edt/services/paypal_service.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentConfirmation extends StatefulWidget {
  String? price;
  String? driverName;
  String? driverUid;
  String? passengerUid;
  String? rideId;
  PaymentConfirmation(
      {super.key,
      required this.price,
      required this.driverName,
      required this.driverUid,
      required this.passengerUid,
      required this.rideId});

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  String selectedOption = 'Payonner';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserExpenses(
      String passengerId, String driverId, double amount) async {
    try {
      DocumentReference passengerDoc =
          _firestore.collection('passengers').doc(passengerId);
      DocumentSnapshot passengerSnapshot = await passengerDoc.get();
      if (passengerSnapshot.exists) {
        double currentExpense = passengerSnapshot['totalExpense'] ?? 0.0;
        double updatedExpense = currentExpense + amount;
        await passengerDoc.update({'totalExpense': updatedExpense});
      }

      DocumentReference driverDoc =
          _firestore.collection('drivers').doc(driverId);

      DocumentSnapshot driverSnapshot = await driverDoc.get();

      if (driverSnapshot.exists) {
        double currentEarnings = driverSnapshot['totalEarnings'] ?? 0.0;
        double updatedEarnings = currentEarnings + amount;

        await driverDoc.update({'totalEarnings': updatedEarnings});
      }
    } catch (e) {
      print('Error updating Firebase: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update payment details')),
      );
    }
  }

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
              getRideContainer(context, widget.driverName ?? ''),
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
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5a5a5a)),
                  ),
                  Spacer(),
                  Text(
                    '\$${widget.price ?? '0.00'}',
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
                    'Payment Method',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5a5a5a)),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              // PaymentMethod(
              //     iconPath: 'assets/icons/visa.svg',
              //     title: '**** **** **** 8970',
              //     subtitle: 'Expires: 12/26',
              //     isSelected: selectedOption == 'Visa',
              //     onTap: () {
              //       setState(() => selectedOption = 'Visa');
              //     }),
              // SizedBox(
              //   height: 10,
              // ),
              // PaymentMethod(
              //     iconPath: 'assets/icons/mastercard.svg',
              //     title: '**** **** **** 8970',
              //     subtitle: 'Expires: 12/26',
              //     isSelected: selectedOption == 'Mastercard',
              //     onTap: () {
              //       setState(() => selectedOption = 'Mastercard');
              //     }),
              // SizedBox(
              //   height: 10,
              // ),
              PaymentMethod(
                  iconPath: 'assets/icons/payonner.svg',
                  title: '**** **** **** 8970',
                  subtitle: 'Pay with PayPal',
                  isSelected: selectedOption == 'Payonner',
                  onTap: () async {
                    // setState(() => selectedOption = 'Payonner');
                  }),
              // SizedBox(
              //   height: 10,
              // ),
              // PaymentMethod(
              //     iconPath: 'assets/icons/cash.svg',
              //     title: '**** **** **** 8970',
              //     subtitle: 'Expires: 12/26',
              //     isSelected: selectedOption == 'Cash',
              //     onTap: () {
              //       setState(() => selectedOption = 'Cash');
              //     }),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );
                      },
                    );

                    final payPalService = PayPalService();
                    PaymentResult paymentResult =
                        await payPalService.createPayment(
                            amount: widget.price ?? '0.00',
                            currency: 'USD',
                            passengerId: widget.passengerUid ?? '',
                            driverId: widget.driverUid ?? '',
                            rideId: widget.rideId ?? '');

                    Navigator.of(context).pop();

                    if (paymentResult.success &&
                        paymentResult.approvalUrl != null) {
                      try {
                        if (await canLaunchUrl(
                            Uri.parse(paymentResult.approvalUrl!))) {
                          await launchUrl(
                            Uri.parse(paymentResult.approvalUrl!),
                            mode: LaunchMode.externalApplication,
                          );

                          showPaymentSuccess(widget.price ?? '0.00');

                          double amount =
                              double.tryParse(widget.price ?? '0.00') ?? 0.0;
                          await updateUserExpenses(widget.passengerUid ?? '',
                              widget.driverUid ?? '', amount);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Could not launch PayPal URL')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error launching PayPal: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                paymentResult.message ?? 'Payment failed')),
                      );
                    }
                  },
                  child: getContainer(context, 'Pay'))
            ],
          ),
        )),
      ),
    );
  }
}
