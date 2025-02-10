import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController? controller;
  final bool enabled;
  final void Function(String)? onPhoneNumberChanged;
  
  const PhoneInputField({
    super.key, 
    this.controller,
    this.enabled = true,
    this.onPhoneNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      enabled: enabled,
      controller: controller,
      disableLengthCheck: true,
      decoration: InputDecoration(
        hintText: 'Your mobile number',
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xffb8b8b8),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffB8B8B8), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffB8B8B8), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffB8B8B8), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
      ),
      initialCountryCode: 'PK',
      showCountryFlag: true,
      showDropdownIcon: false,
      onChanged: (phone) {
        // Format the phone number in E.164 format
        String formattedNumber = '';
        if (phone.number.startsWith('0')) {
          // Remove leading zero if present
          formattedNumber = '+${phone.countryCode}${phone.number.substring(1)}';
        } else {
          formattedNumber = '+${phone.countryCode}${phone.number}';
        }
        
        // Update the controller with the E.164 formatted number
        if (controller != null) {
          controller!.text = formattedNumber;
        }
        
        // Provide the formatted number through the callback
        if (onPhoneNumberChanged != null) {
          onPhoneNumberChanged!(formattedNumber);
        }
      },
      inputFormatters: [],
      style: const TextStyle(fontSize: 16),
    );
  }
}