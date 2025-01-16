import 'package:edt/pages/home/widgets/thanks_dialog.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

void getFeedbackSheet(BuildContext context) {
  showModalBottomSheet(
    // isDismissible: false,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.63,
              ),
              child: Container(
                height: getHeight(context) * 0.63,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 130.0),
                      child: Divider(
                        thickness: 3,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          5,
                          (index) => SvgPicture.asset(
                                'assets/icons/star.svg',
                                width: 25,
                                height: 25,
                              )),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Excellent',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xff2a2a2a)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You rated Sergio Ramasis 4 star',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xffb8b8b8)),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      height: 120.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Write your text',
                            hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffd0d0d0)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
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
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Give some tips to Sergio Ramasis',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xff5a5a5a)),
                    ),
                    
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 13,
                        children: [
                          TipSelectionWidget(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Give some tips to Sergio Ramasis',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xff0F69DB)),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          thanksDialog(context);
                        },
                        child: getContainer(context, 'Submit')),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}


class TipSelectionWidget extends StatefulWidget {
  @override
  _TipSelectionWidgetState createState() => _TipSelectionWidgetState();
}

class _TipSelectionWidgetState extends State<TipSelectionWidget> {
  int _selectedIndex = 0;

  List<String> tips = ['1', '2', '5', '10', '20'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tips.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _selectedIndex == index ? Colors.blue : Color(0xffdddddd),
                ),
              ),
              child: Center(
                child: Text(
                  '\$${tips[index]}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff5a5a5a),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

