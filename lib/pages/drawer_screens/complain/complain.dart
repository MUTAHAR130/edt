import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edt/pages/drawer_screens/complain/widget/complain_dialog.dart';
import 'package:edt/widgets/container.dart';
import 'package:edt/widgets/text_field.dart';

class ComplainScreen extends StatefulWidget {
  const ComplainScreen({super.key});

  @override
  _ComplainScreenState createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitComplaint() async {
    String title = _titleController.text.trim();
    String subject = _subjectController.text.trim();
    User? user = FirebaseAuth.instance.currentUser;

    if (title.isEmpty || subject.isEmpty) {
      EasyLoading.showError('Please fill out all fields');
      return;
    }

    EasyLoading.show(status: 'Submitting...');

    try {

      await _firestore.collection('complains').add({
        'uid':user?.uid,
        'complainTitle': title,
        'complainSubject': subject,
        'timestamp': FieldValue.serverTimestamp(),
      });

      EasyLoading.dismiss();
      complainDialog(context);

      _titleController.clear();
      _subjectController.clear();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Failed to submit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
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
                            const Icon(Icons.arrow_back_ios,
                                size: 24, color: Color(0xff414141)),
                            Text(
                              'Back',
                              style: GoogleFonts.poppins(
                                color: const Color(0xff414141),
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
                            'Complain',
                            style: GoogleFonts.poppins(
                              color: const Color(0xff2a2a2a),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  hintText: 'Subject of Complain',
                  controller: _titleController,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120.0,
                  child: TextField(
                    controller: _subjectController,
                    maxLength: 100,
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintMaxLines: 100,
                      border: OutlineInputBorder(),
                      hintText: 'Write your complain here (max 100 characters)',
                      hintStyle: GoogleFonts.poppins(
                          color: Color(0xffb8b8b8),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffb8b8b8))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    maxLines: null,
                    expands: true,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _submitComplaint,
                  child: getContainer(context, 'Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
