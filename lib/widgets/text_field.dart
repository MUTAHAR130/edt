import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? imagePath;
  final VoidCallback? onTap;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              color: Color(0xffb8b8b8),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffB8B8B8), width: 1),
            ),
            suffixIcon: imagePath != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      imagePath!,
                    ),
                  ],
                )
                : null,
          ),
          style: TextStyle(color: Colors.black),
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}
