import 'package:edt/pages/drawer_screens/address/address.dart';
import 'package:edt/pages/drawer_screens/complain/complain.dart';
import 'package:edt/pages/drawer_screens/emergency/emergency.dart';
import 'package:edt/pages/drawer_screens/help_and_support/help_and_support.dart';
import 'package:edt/pages/drawer_screens/history/history.dart';
import 'package:edt/pages/drawer_screens/about_us/about_us.dart';
import 'package:edt/pages/drawer_screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

Drawer getDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // Drawer Header with Profile Info
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                height: 10,
              ),
              CircleAvatar(
                radius: 35,
                child: Center(
                  child: Icon(Icons.person),
                ),
                // backgroundImage: AssetImage(
                //     'assets/profile.jpg'),
              ),
              SizedBox(height: 8),
              Text(
                'Nate Samson',
                style: GoogleFonts.poppins(
                  color: Color(0xff414141),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'nate@email.com',
                style: GoogleFonts.poppins(
                  color: Color(0xff414141),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 26,
              )
            ],
          ),
        ),

        _buildDrawerItem('assets/icons/dicon1.svg', 'Edit Profile',(){}),
        _buildDrawerItem('assets/icons/dicon2.svg', 'Address',(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressScreen()));
        }),
        _buildDrawerItem('assets/icons/dicon3.svg', 'History',(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryScreen()));
        }),
        _buildDrawerItem('assets/icons/dicon4.svg', 'Complain',(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ComplainScreen()));
        }),
        _buildDrawerItem('assets/icons/dicon5.svg', 'Rewards',(){}),
        _buildDrawerItem('assets/icons/dicon6.svg', 'About Us',(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsScreen()));
        }),
        _buildDrawerItem('assets/icons/dicon7.svg', 'Settings',(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));
        }),
        _buildDrawerItem('assets/icons/dicon8.svg', 'Emergency',(){
          Navigator.pop(context);
          emergencySheet(context);
        }),
        _buildDrawerItem('assets/icons/dicon9.svg', 'Help and Support',(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpAndSupport()));
        }),
        _buildDrawerItem('assets/icons/dicon10.svg', 'Logout',(){}),
      ],
    ),
  );
}

Widget _buildDrawerItem(String iconPath, String title,VoidCallback? onTap) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Divider(
        color: Color(0xffE8E8E8),
      ),
      ListTile(
        tileColor: Colors.white,
        leading:
            SizedBox(width: 20, height: 20, child: SvgPicture.asset(iconPath)),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Color(0xff414141),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    ],
  );
}
