import 'package:edt/pages/authentication/enable_location/enable_loc.dart';
import 'package:edt/pages/authentication/enable_location/welcome.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DriverPassenger extends StatefulWidget {
  const DriverPassenger({super.key});

  @override
  State<DriverPassenger> createState() => _DriverPassengerState();
}

class _DriverPassengerState extends State<DriverPassenger> {
  List<Map<String, String>> options = [
    {'image': 'assets/images/driver.png', 'text': 'Driver'},
    {'image': 'assets/images/passenger.png', 'text': 'Passenger'},
  ];

  Future<void> _handleContinuePress(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EnableLocation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var userRoleProvider = Provider.of<UserRoleProvider>(context);

    return Scaffold(
      appBar: getBackButton(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Choose Your Journey',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xff2a2a2a),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Would you like to take the wheel as a Rider or enjoy the journey as a Passenger?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xffa0a0a0),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Column(
                          children: List.generate(options.length, (index) {
                            String imgPath = options[index]['image']!;
                            String text = options[index]['text']!;
                            bool isSelected = userRoleProvider.role == text;

                            return GestureDetector(
                              onTap: () {
                                userRoleProvider.setRole(text);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: isSelected
                                            ? Border.all(
                                                color: const Color(0xff0F69DB),
                                                width: 1.0,
                                              )
                                            : null,
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(imgPath),
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xff0F69DB)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check,
                                              size: 16,
                                              color: Color(0xff0F69DB))
                                          : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        text,
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xff0F69DB),
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: userRoleProvider.role.isNotEmpty
                              ? () => _handleContinuePress(context)
                              : null,
                          child: Container(
                            height: 55,
                            margin: const EdgeInsets.symmetric(vertical: 25.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: userRoleProvider.role.isEmpty
                                  ? const Color(0xffB0B0B0)
                                  : const Color(0xff163051),
                            ),
                            child: Center(
                              child: Text(
                                'Continue',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
