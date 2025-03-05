import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/expense_tracking/provider/expense_provider.dart';
import 'package:edt/pages/notification/notification.dart';
import 'package:edt/utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class PaymentDetail {
  final String name;
  final String imageUrl;
  final Timestamp verifiedAt;
  final String amount;

  PaymentDetail({
    required this.name, 
    required this.imageUrl, 
    required this.verifiedAt, 
    required this.amount
  });
}

class ExpenseTrackingScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ExpenseTrackingScreen({super.key, required this.scaffoldKey});

  @override
  State<ExpenseTrackingScreen> createState() => _ExpenseTrackingScreenState();
}

class _ExpenseTrackingScreenState extends State<ExpenseTrackingScreen> {
  // double _totalAmount = 0.0;
  // int _totalDeliveries=0;
  // List<PaymentDetail> _paymentDetails = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchTotalAmount();
  //   _fetchPaymentDetails();
  // }

  // Future<void> _fetchPaymentDetails() async {
  //   try {
  //     User? currentUser = FirebaseAuth.instance.currentUser;
  //     if (currentUser == null) return;

  //     UserRoleProvider userPro = Provider.of<UserRoleProvider>(context, listen: false);
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     QuerySnapshot paymentsSnapshot;
  //     if (userPro.role == 'Passenger') {
  //       // Fetch payments for passenger
  //       paymentsSnapshot = await firestore
  //           .collection('payments')
  //           .where('passengerId', isEqualTo: currentUser.uid)
  //           .get();

  //       // Process payments and fetch driver details
  //       List<PaymentDetail> details = [];
  //       for (var paymentDoc in paymentsSnapshot.docs) {
  //         var paymentData = paymentDoc.data() as Map<String, dynamic>;
          
  //         // Fetch driver details
  //         var driverDoc = await firestore
  //             .collection('drivers')
  //             .doc(paymentData['driverId'])
  //             .get();
          
  //         details.add(PaymentDetail(
  //           name: driverDoc['fullname'] ?? 'Unknown Driver',
  //           imageUrl: driverDoc['driverImage'] ?? '',
  //           verifiedAt: paymentData['verifiedAt'],
  //           amount: paymentData['amount']?? 0.0
  //         ));
  //       }

  //       setState(() {
  //         _paymentDetails = details;
  //       });
  //     } else if (userPro.role == 'Driver') {
  //       paymentsSnapshot = await firestore
  //           .collection('payments')
  //           .where('driverId', isEqualTo: currentUser.uid)
  //           .get();

  //       List<PaymentDetail> details = [];
  //       for (var paymentDoc in paymentsSnapshot.docs) {
  //         var paymentData = paymentDoc.data() as Map<String, dynamic>;
          
  //         var passengerDoc = await firestore
  //             .collection('passengers')
  //             .doc(paymentData['passengerId'])
  //             .get();
          
  //         details.add(PaymentDetail(
  //           name: passengerDoc['username'] ?? 'Unknown Passenger',
  //           imageUrl: passengerDoc['passengerImage'] ?? '',
  //           verifiedAt: paymentData['verifiedAt'],
  //           amount: paymentData['amount']?? 0.0
  //         ));
  //       }

  //       setState(() {
  //         _paymentDetails = details;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error fetching payment details: $e');
  //   }
  // }

  // Future<void> _fetchTotalAmount() async {
  //   try {
  //     User? currentUser = FirebaseAuth.instance.currentUser;
  //     if (currentUser == null) return;

  //     UserRoleProvider userPro = Provider.of<UserRoleProvider>(context, listen: false);

  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     DocumentSnapshot userDoc;
  //     if (userPro.role == 'Passenger') {
  //       userDoc = await firestore
  //           .collection('passengers')
  //           .doc(currentUser.uid)
  //           .get();

  //       setState(() {
  //         _totalAmount = (userDoc.data() as Map<String, dynamic>?)?['totalExpense']?.toDouble() ?? 0.0;
  //       });
  //     } else if (userPro.role == 'Driver') {
  //       userDoc = await firestore
  //           .collection('drivers')
  //           .doc(currentUser.uid)
  //           .get();

  //       setState(() {
  //         _totalAmount = (userDoc.data() as Map<String, dynamic>?)?['totalEarnings']?.toDouble() ?? 0.0;
  //         _totalDeliveries = (userDoc.data() as Map<String, dynamic>?)?['totalDeliveries'] ?? 0;
  //       });
  //       // print(userDoc.data());

  //     }
  //   } catch (e) {
  //     print('Error fetching total amount: $e');
  //     setState(() {
  //       _totalAmount = 0.0;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    var userPro = Provider.of<UserRoleProvider>(context);
    var paymentProvider = Provider.of<PaymentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                final scaffold = Scaffold.of(context);
                if (scaffold.hasDrawer) {
                  scaffold.openDrawer();
                } else {
                  widget.scaffoldKey.currentState?.openDrawer();
                }
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xffe7f0fc)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/bars.svg'),
                  ],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          userPro.role == 'Passenger' ? 'Expense Tracking' : 'Earn',
          style: GoogleFonts.poppins(
              color: Color(0xff2a2a2a),
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
        actions: [
          userPro.role == 'Passenger'?
          SizedBox.shrink():
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/notification.svg'),
                ],
              ),
            ),
          ),
          userPro.role == 'Passenger'
              ? GestureDetector(
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xffe7f0fc)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/notification.svg'),
                        ],
                      ),
                    ),
                ),
              )
              : SizedBox.shrink()
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 34,
              ),
              Container(
                height: getHeight(context) * 0.2,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff0F69DB), Color(0xff163051)])),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$${paymentProvider.totalAmount.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 60,
                            color: Color(0xffffffff)),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      Text(
                        userPro.role=='Passenger'?
                        'Total Expense':'Total Earnings',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffffffff)),
                      ),
                    ],
                  ),
                ),
              ),
              userPro.role=='Passenger'?
              SizedBox.shrink():
              SizedBox(
                height: 30,
              ),
              userPro.role=='Passenger'?
              SizedBox.shrink():
              Row(
                children: [
                  // Expanded(
                  //   child: Container(
                  //     height: 110,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(5),
                  //         color: Color(0xffcfe1f8)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 10.0),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Container(
                  //               width: 33,
                  //               height: 33,
                  //               decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   color: Color(0xff0F69DB)),
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   SvgPicture.asset('assets/icons/clock1.svg'),
                  //                 ],
                  //               )),
                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           Text(
                  //             'Time',
                  //             textAlign: TextAlign.center,
                  //             style: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 14,
                  //                 color: Color(0xff000000)),
                  //           ),
                  //           Text(
                  //             '42h 32m',
                  //             textAlign: TextAlign.center,
                  //             style: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 12,
                  //                 color: Color(0xff000000)),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 36,
                  // ),
                  Expanded(
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffcfe1f8)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 33,
                                height: 33,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff0F69DB)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/deliveries.svg'),
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Deliveries',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xff000000)),
                            ),
                            Text(
                              paymentProvider.totalDeliveries.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xff000000)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox(),)
                ],
              ),
              userPro.role=='Passenger'?
              SizedBox.shrink():
              SizedBox(
                height: 30,
              ),
              userPro.role=='Passenger'?
              SizedBox(
                height: 25,
              ):
              SizedBox.shrink(),
              Row(
                children: [
                  Text(
                    userPro.role=='Driver'?
                    'Payment Details':
                    'Expenses',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff414141)),
                  ),
                  // Spacer(),
                  // Text(
                  //   'See All',
                  //   textAlign: TextAlign.center,
                  //   style: GoogleFonts.poppins(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 12,
                  //       color: Color(0xff0F69DB)),
                  // ),
                ],
              ),
              paymentProvider.isLoading?Center(child: CircularProgressIndicator(color: Colors.blue,)):
              ListView.builder(
                  itemCount: paymentProvider.paymentDetails.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var payment = paymentProvider.paymentDetails[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: 65,
                        width: getWidth(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Color(0xff0F69DB), width: 0.5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: 
                                    userPro.role=='Driver'?
                                    Color(0xffcfe1f8):
                                    Color(0xffFFCDD2),
                                    image: payment.imageUrl.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(payment.imageUrl),
                                            fit: BoxFit.cover
                                          )
                                        : null),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    payment.name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xff121212)),
                                  ),
                                  Text(
                                    _formatTimestamp(payment.verifiedAt),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xff5a5a5a)),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                '${userPro.role == 'Passenger' ? '-' : '+'}\$${payment.amount}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xff121212)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 70,)
            ],
          ),
        ),
      ),
    );
  }
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    // You can customize the date format as needed
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
