import 'package:edt/pages/driver_home/widgets/driver_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class DriverHomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DriverHomeScreen({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  final scaffold = Scaffold.of(context);
                  if (scaffold.hasDrawer) {
                    scaffold.openDrawer();
                  } else {
                    scaffoldKey.currentState?.openDrawer();
                  }
                },
                child: SvgPicture.asset('assets/icons/bars.svg')),
          ],
        ),
        title: Text(
          'You are Offline!',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xff111111)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SvgPicture.asset('assets/icons/notification.svg'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SvgPicture.asset('assets/icons/red_button.svg'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xff0F69DB), Color(0xff163051)])),
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
                                    color: Color(0xff407cc9)),
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
                                  color: Color(0xffffffff)),
                            ),
                            Text(
                              '42h 32m',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xffffffff)),
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
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xff0F69DB), Color(0xff163051)])),
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
                                    color: Color(0xff407cc9)),
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
                                  color: Color(0xffffffff)),
                            ),
                            Text(
                              '38',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xffffffff)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: Color(0xffE5E5E5),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Would you like to specify direction for deliveries?',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff111111)),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    color: Color(0xfff0f5f5),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xff0F69DB),width: 2)
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Where to?',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xffafafaf)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    'Available Requests',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xff111111)),
                  ),
                  Spacer(),
                  Text(
                    'View all',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xff163051)),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        IntrinsicHeight(
                          child: SizedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey[200]),
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
                                              fontSize: 14,
                                              color: Color(0xff000000)),
                                        ),
                                        Text(
                                          '+923439433435',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Color(0xff545454)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Container(
                                      width: 35,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xfff7f7f7)
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset('assets/icons/car.svg'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,color: Color(0xff0F69DB),size: 12,),
                                            Text(
                                              'Drop off',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                  color: Color(0xff545454)),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Maryland bustop, Anthony Ikeja',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Color(0xff000000)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Color(0xffFf3f7fd)
                                        ),
                                        child: Center(
                                          child: Text('Reject',style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Color(0xff163051)),),
                                        ),
                                      )),
                                      SizedBox(width: 16,),
                                      Expanded(child: GestureDetector(
                                        onTap: () {
                                          getDriverDetailsSheet(context);
                                        },
                                        child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Color(0xffF163051)
                                          ),
                                          child: Center(
                                            child: Text('Accept',style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color(0xffffffff)),),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Divider(color: Color(0xffDCE8E9),),
                        SizedBox(height: 10,),
                      ],
                    );
                  }),
                  SizedBox(height: 70,)
            ],
          ),
        ),
      ),
    );
  }
}
