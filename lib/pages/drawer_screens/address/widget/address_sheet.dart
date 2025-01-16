import 'package:edt/pages/home/widgets/sheet_text_field.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void addressSheet(BuildContext context) {
  showModalBottomSheet(
    // isDismissible: false,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.46,
            ),
            child: Container(
              height: getHeight(context) * 0.46,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 130.0),
                    child: Divider(
                      thickness: 3,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Address Details',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2a2a2a))),
                  SizedBox(height: 15),
                  Divider(
                    color: Color(0xffdddddd),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SheetTextField(
                      hintText: 'Name of Address',
                      imagePath: 'assets/icons/loc_from.svg',
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 120.0,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'Address Details',
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
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: getContainer(context, 'Add Address'),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
