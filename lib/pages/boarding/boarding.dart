import 'package:edt/pages/boarding/content_model.dart';
import 'package:edt/pages/boarding/driver_passenger.dart';
import 'package:edt/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / contents.length;
    // Get the screen height and width
    final screenHeight = getHeight(context);
    final screenWidth = getWidth(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        primary: true,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DriverPassenger()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                'Skip',
                style: GoogleFonts.poppins(
                  color: const Color(0xff414141),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.6,
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      itemCount: contents.length,
                      onPageChanged: (int index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (_, i) {
                        return Column(
                          children: [
                            SizedBox(height: screenHeight * 0.1),
                            SizedBox(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.35,
                              child: Image.asset(
                                contents[i].image,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.9,
                              child: Text(
                                contents[i].title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff2a2a2a),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: screenWidth * 0.7,
                              child: Text(
                                contents[i].description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xffa0a0a0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      if (currentIndex < contents.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DriverPassenger()));
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: progress),
                            duration: const Duration(milliseconds: 400),
                            builder: (context, value, child) {
                              return CircularProgressIndicator(
                                value: value,
                                strokeWidth: 4,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xff0F69DB)),
                                backgroundColor: Colors.blue[100],
                              );
                            },
                          ),
                        ),
                        Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.all(80),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff163051)),
                            child: Center(
                                child: currentIndex == contents.length - 1
                                    ? Text(
                                        'Go',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xffffffff),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
