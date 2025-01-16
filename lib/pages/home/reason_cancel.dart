import 'package:edt/pages/home/widgets/sad.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelReason extends StatefulWidget {
  BuildContext context;
  CancelReason({super.key,required this.context});

  @override
  State<CancelReason> createState() => _CancelReasonState();
}

class _CancelReasonState extends State<CancelReason> {
  final List<bool> _selectedIndices = List<bool>.filled(6, false);
  @override
  Widget build(BuildContext context) {
    final reasons = [
      'Waiting for long time',
      'Unable to contact driver',
      'Driver denied to go to destination',
      'Driver denied to come to pickup',
      'Wrong address shown',
      'The price is not reasonable',
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: Color(0xff414141),
                          ),
                          Text(
                            'Back',
                            style: GoogleFonts.poppins(
                              color: Color(0xff414141),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Cancel Taxi',
                          style: GoogleFonts.poppins(
                            color: Color(0xff2a2a2a),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Please select the reason of cancellation.',
                style: GoogleFonts.poppins(
                    color: Color(0xffb8b8b8),
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                children: reasons
                    .asMap()
                    .entries
                    .map((entry) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndices[entry.key] =
                                  !_selectedIndices[entry.key];
                            });
                          },
                          child: Container(
                            height: 65,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: _selectedIndices[entry.key]
                                    ? Color(0xFFFEC400)
                                    : Color(0xFFD0D0D0),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _selectedIndices[entry.key],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _selectedIndices[entry.key] = value!;
                                    });
                                  },
                                  checkColor: Colors.white,
                                  activeColor: Color(0xFF43A048),
                                ),
                                Text(
                                  entry.value,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xff5a5a5a)),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 120.0,
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Other',
                    hintStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xffd0d0d0)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffb8b8b8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
              SizedBox(height: 110,),
              GestureDetector(
                onTap: () {
                  sadDialog(context);
                },
                child: getContainer(context, 'Submit'))
            ],
          ),
        )),
      ),
    );
  }
}
