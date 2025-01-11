import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class GetSelectionContainer extends StatelessWidget {
  final String iconPath;
  final String via;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const GetSelectionContainer({
    super.key,
    required this.iconPath,
    required this.via,
    required this.subtitle,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xff0F69DB) : Color(0xff80afec),
            width: 1.5,
          ),
          color: isSelected ? Color(0xffcfe1f8) : Color(0xfff3f7fd),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? Color(0xff0F69DB) : Color(0xff80afec)),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: SvgPicture.asset(iconPath),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      via,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Color(0xffb8b8b8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Color(0xff5a5a5a),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
