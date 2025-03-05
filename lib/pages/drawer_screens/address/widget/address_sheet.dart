import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:svg_flutter/svg.dart';

void addressSheet(BuildContext context,
    {bool isEditing = false, String? addressId, String addressName = '', String addressDetails = ''}) {
  TextEditingController nameController = TextEditingController(text: addressName);
  TextEditingController detailsController = TextEditingController(text: addressDetails);

  showModalBottomSheet(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 130.0),
                    child: const Divider(thickness: 3),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isEditing ? 'Edit Address' : 'Address Details',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xff2a2a2a)),
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Color(0xffdddddd)),
                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 50.0,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/loc_from.svg'),
                            ],
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Name of Address',
                          hintStyle: GoogleFonts.poppins(
                              color: Color(0xffb8b8b8), fontSize: 15, fontWeight: FontWeight.w500),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide(color: Color(0xffb8b8b8))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 120.0,
                      child: TextField(
                        controller: detailsController,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Address Details',
                          hintStyle: GoogleFonts.poppins(
                              color: Color(0xffb8b8b8), fontSize: 15, fontWeight: FontWeight.w500),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide(color: Color(0xffb8b8b8))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        ),
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (nameController.text.isEmpty || detailsController.text.isEmpty) return;

                      EasyLoading.show(status: 'Saving...');
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      String uid = FirebaseAuth.instance.currentUser!.uid;

                      if (isEditing) {
                        await firestore.collection('addresses').doc(addressId).update({
                          'addressName': nameController.text.trim(),
                          'addressDetails': detailsController.text.trim(),
                        });
                      } else {
                        await firestore.collection('addresses').add({
                          'uid': uid,
                          'addressName': nameController.text.trim(),
                          'addressDetails': detailsController.text.trim(),
                        });
                      }
                      EasyLoading.dismiss();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: getContainer(context, isEditing ? 'Update Address' : 'Add Address'),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
