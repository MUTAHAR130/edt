import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneInputField extends StatelessWidget {
  TextEditingController? controller;
  final bool enabled;
  PhoneInputField({super.key,this.controller,this.enabled=true});
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      enabled: enabled,
      controller: controller,
      disableLengthCheck: true,
      decoration: InputDecoration(
        hintText: 'Your mobile number',
        hintStyle: GoogleFonts.poppins(
          color: Color(0xffb8b8b8),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.0),
      ),
      initialCountryCode: 'PK',
      showCountryFlag: true,
      showDropdownIcon: false,
      onChanged: (phone) {
        print(phone.completeNumber);
      },
      inputFormatters: [],
      style: TextStyle(fontSize: 16),
    );
  }
}
