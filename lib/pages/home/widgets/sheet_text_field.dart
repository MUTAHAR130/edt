import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class SheetTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? imagePath;
  final VoidCallback? onTap;
  final bool readOnly;

  const SheetTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.imagePath,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        // height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xffB8B8B8), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                if (imagePath != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SvgPicture.asset(imagePath!),
                  ),
                Expanded(
                  child: Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    hintText ?? '',
                    style: GoogleFonts.poppins(
                      color: Color(0xff5a5a5a),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}