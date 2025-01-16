import 'package:edt/pages/drawer_screens/complain/widget/complain_dialog.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplainScreen extends StatelessWidget {
  const ComplainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                          const Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: Color(0xff414141),
                          ),
                          Text(
                            'Back',
                            style: GoogleFonts.poppins(
                              color: const Color(0xff414141),
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
                          'Complain',
                          style: GoogleFonts.poppins(
                            color: const Color(0xff2a2a2a),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                hintText: 'Vehicle Not Clean',
                imagePath: 'assets/icons/arrow_down.svg',
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 120.0,
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        'Write your complain here (minimum 10 characters)',
                    hintStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xffd0d0d0)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffb8b8b8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  complainDialog(context);
                },
                child: getContainer(context, 'Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
