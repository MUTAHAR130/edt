import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

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
                          'Help and Support',
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
              IntrinsicHeight(
                  child: Text(
                'Are you sure you want to delete your account? Please read how account deletion will affect.Deleting your account removes personal information our database. Tour email becomes permanently reserved and same email cannot be re-use to register a new account.',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff5a5a5a)),
              )),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xffBD0A00)),
                child: Center(
                    child: Text(
                  'Delete',
                  style: GoogleFonts.poppins(
                    color: Color(0xffffffff),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
