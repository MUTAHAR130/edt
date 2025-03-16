import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/expense_tracking/provider/expense_provider.dart';
import 'package:edt/pages/notification/notification.dart';
import 'package:edt/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class ExpenseTrackingScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ExpenseTrackingScreen({super.key, required this.scaffoldKey});

  @override
  State<ExpenseTrackingScreen> createState() => _ExpenseTrackingScreenState();
}

class _ExpenseTrackingScreenState extends State<ExpenseTrackingScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final userPro = Provider.of<UserRoleProvider>(context);
      final paymentProvider =
          Provider.of<PaymentProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (paymentProvider.paymentDetails.isEmpty ||
            paymentProvider.needsRefresh) {
          paymentProvider.fetchPaymentAndExpenseData(userPro.role);
        }
      });

      _isInitialized = true;
    }
  }

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
          userPro.role == 'Passenger'
              ? SizedBox.shrink()
              : Padding(
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
      body: RefreshIndicator(
        onRefresh: () async {
          // Force refresh data
          await paymentProvider.fetchPaymentAndExpenseData(userPro.role);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                              fontSize: 50,
                              color: Color(0xffffffff)),
                        ),
                        SizedBox(
                          height: 21,
                        ),
                        Text(
                          userPro.role == 'Passenger'
                              ? 'Total Expense'
                              : 'Total Earnings',
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
                userPro.role == 'Passenger'
                    ? SizedBox.shrink()
                    : SizedBox(
                        height: 30,
                      ),
                userPro.role == 'Passenger'
                    ? SizedBox.shrink()
                    : Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 110,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xffcfe1f8)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff0F69DB)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/icons/deliveries.svg'),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Deliveries',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xff000000)),
                                        ),
                                        Text(
                                          paymentProvider.totalDeliveries
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color(0xff000000)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                userPro.role == 'Passenger'
                    ? SizedBox.shrink()
                    : SizedBox(
                        height: 30,
                      ),
                userPro.role == 'Passenger'
                    ? SizedBox(
                        height: 25,
                      )
                    : SizedBox.shrink(),
                Row(
                  children: [
                    Text(
                      userPro.role == 'Driver' ? 'Payment Details' : 'Expenses',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff414141)),
                    ),
                  ],
                ),
                paymentProvider.isLoading
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ))
                    : paymentProvider.paymentDetails.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                'No ${userPro.role == 'Driver' ? 'payment' : 'expense'} details found',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xff5a5a5a),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: paymentProvider.paymentDetails.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var payment =
                                  paymentProvider.paymentDetails[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  height: 65,
                                  width: getWidth(context),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Color(0xff0F69DB),
                                          width: 0.5)),
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
                                              color: userPro.role == 'Driver'
                                                  ? Color(0xffcfe1f8)
                                                  : Color(0xffFFCDD2),
                                              image: payment.imageUrl.isNotEmpty
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          payment.imageUrl),
                                                      fit: BoxFit.cover)
                                                  : null),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              _formatTimestamp(
                                                  payment.verifiedAt),
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
                SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    // Format with padded minutes
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
