import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final bool? enabled;

  const PasswordField({
    Key? key,
    this.controller,
    required this.hintText,
    this.onTap,
    this.keyboardType,
    this.enabled,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 60,
        child: TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          decoration: InputDecoration(
            hintText: widget.hintText,
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
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  _obscure
                      ? 'assets/icons/visibility_off.svg'
                      : 'assets/icons/visibility_on.svg',
                ),
              ),
            ),
          ),
          style: TextStyle(color: Colors.black),
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}
