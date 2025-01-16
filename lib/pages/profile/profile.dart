import 'package:edt/pages/authentication/signup/widgets/phone_field.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
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
                SvgPicture.asset('assets/icons/bars.svg'),
              ],
            ),
          ),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
              color: Color(0xff2a2a2a),
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: 138,
              height: 138,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
              child: Center(
                child: Icon(Icons.person),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Nate Samson',
              style: GoogleFonts.poppins(
                  color: Color(0xff5a5a5a),
                  fontWeight: FontWeight.w500,
                  fontSize: 28),
            ),
            SizedBox(height: 24,),
            CustomTextFormField(hintText: 'Email'),
            SizedBox(height: 10,),
            PhoneInputField(),
            SizedBox(height: 10,),
            CustomTextFormField(hintText: 'Gender',imagePath: 'assets/icons/arrow_down.svg',),
            SizedBox(height: 10,),
            CustomTextFormField(hintText: 'Address'),
            SizedBox(height: 32,),
            getContainer(context, 'Update')
          ],
        ),
      ),
    );
  }
}
