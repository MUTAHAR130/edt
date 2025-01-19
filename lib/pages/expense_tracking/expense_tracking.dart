import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class ExpenseTrackingScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ExpenseTrackingScreen({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    var userPro = Provider.of<UserRoleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              final scaffold = Scaffold.of(context);
              if (scaffold.hasDrawer) {
                scaffold.openDrawer();
              } else {
                scaffoldKey.currentState?.openDrawer();
              }
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xff0F69DB1A)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/bars.svg'),
                ],
              ),
            ),
          ),
        ),
        title: Text(
          userPro.role == 'Passenger' ? 'Expense Tracking' : 'Earn',
          style: GoogleFonts.poppins(
              color: Color(0xff2a2a2a),
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xff0F69DB1A)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userPro.role == 'Passenger'
                      ? SvgPicture.asset('assets/icons/search.svg')
                      : SvgPicture.asset('assets/icons/notification.svg'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 8),
            child: userPro.role == 'Passenger'
                ? Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xff0F69DB1A)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/notification.svg'),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/red_button.svg'),
                    ],
                  ),
          ),
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
                        '\$200',
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
                                    SvgPicture.asset('assets/icons/clock1.svg'),
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Time',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xff000000)),
                            ),
                            Text(
                              '42h 32m',
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
                  SizedBox(
                    width: 36,
                  ),
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
                              '38',
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
                  )
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
                  Spacer(),
                  Text(
                    'See All',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xff0F69DB)),
                  ),
                ],
              ),
              ListView.builder(
                  itemCount: 15,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                    Color(0xffFFCDD2)),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Column(
                                spacing: 3,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welton',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xff121212)),
                                  ),
                                  Text(
                                    'Today at 09:20 am',
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
                                '-\$570.00',
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
