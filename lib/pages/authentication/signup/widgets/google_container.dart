import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class CustomContainer extends StatelessWidget {
  final String svgPicture;
  const CustomContainer({super.key, required this.svgPicture});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          border:Border.all(color:Color(0xffD0D0D0) ) ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgPicture),
        ],
      ),
    );
  }
}
