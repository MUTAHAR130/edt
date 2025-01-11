import 'package:edt/pages/authentication/enable_location/enable_loc.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverPassenger extends StatefulWidget {
  const DriverPassenger({super.key});

  @override
  State<DriverPassenger> createState() => _DriverPassengerState();
}

class _DriverPassengerState extends State<DriverPassenger> {
  String _selectedOption = '';

  List<Map<String, String>> options = [
    {'image': 'assets/images/driver.png', 'text': 'Driver'},
    {'image': 'assets/images/passenger.png', 'text': 'Passenger'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackButton(context),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              'Choose Your Journey',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Color(0xff2a2a2a),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Would you like to take the wheel as a Rider or enjoy the journey as a Passenger?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Color(0xffa0a0a0),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 40),
            Column(
              children: List.generate(options.length, (index) {
                String imgPath = options[index]['image']!;
                String text = options[index]['text']!;
                bool isSelected = _selectedOption == text;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOption = text;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Color(0xff0F69DB), width: 1.0)
                                : null,
                          ),
                          child: ClipOval(
                            child: Image.asset(imgPath),
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff0F69DB)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: isSelected
                              ? Icon(Icons.check,
                                  size: 16, color: Color(0xff0F69DB))
                              : null,
                        ),
                        SizedBox(width: 10),
                        Text(
                          text,
                          style: GoogleFonts.poppins(
                            color: Color(0xff0F69DB),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Spacer(),
            GestureDetector(
              onTap: _selectedOption.isNotEmpty
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnableLocation()));
                    }
                  : null,
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _selectedOption.isEmpty
                        ? Color(0xffB0B0B0)
                        : Color(0xff163051)),
                child: Center(
                    child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                    color: Color(0xffffffff),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
