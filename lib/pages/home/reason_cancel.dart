import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/home/widgets/sad.dart';
import 'package:edt/widgets/container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CancelReason extends StatefulWidget {
  final BuildContext context;
  final String? rideId;
  final String? vehicleName;
  final double? amount;
  
  CancelReason({super.key, required this.context, this.rideId,this.amount,this.vehicleName});

  @override
  State<CancelReason> createState() => _CancelReasonState();
}

class _CancelReasonState extends State<CancelReason> {
  final List<bool> _selectedIndices = List<bool>.filled(6, false);
  final TextEditingController _otherReasonController = TextEditingController();
  bool isLoading = false;
  
  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  Future<void> cancelRide() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get the ride document
      final rideDoc = await FirebaseFirestore.instance
          .collection('rides')
          .doc(user.uid)
          .get();
      
      if (!rideDoc.exists) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      final rideData = rideDoc.data() as Map<String, dynamic>;
      
      String reason = '';
      final reasons = [
        'Waiting for long time',
        'Unable to contact driver',
        'Driver denied to go to destination',
        'Driver denied to come to pickup',
        'Wrong address shown',
        'The price is not reasonable',
      ];
      
      for (int i = 0; i < _selectedIndices.length; i++) {
        if (_selectedIndices[i]) {
          reason = reasons[i];
          break;
        }
      }
      
      if (reason.isEmpty && _otherReasonController.text.isNotEmpty) {
        reason = _otherReasonController.text;
      }
      
      if (reason.isEmpty) {
        reason = "No reason provided";
      }
      
      var rolePro=Provider.of<UserRoleProvider>(context,listen: false);
      await FirebaseFirestore.instance
          .collection('history')
          .doc(user.uid)
          .set({
        'passengerUid': user.uid,
        'driverUid': rideData['driverId'] ?? '',
        'price':widget.amount,
        'rideId':widget.rideId,
        'role':rolePro.role,
        'status':'cancelled',
        'timestamp': FieldValue.serverTimestamp(),
        'vehicleName':widget.vehicleName,
        'cancelReason': reason,
        'ride': rideData,
      });
      
      await FirebaseFirestore.instance
          .collection('rides')
          .doc(user.uid)
          .delete();

      sadDialog(context
      // , onClose: () {
      //   Navigator.popUntil(context, (route) => route.isFirst);
      // }
      );
    } catch (e) {
      print('Error cancelling ride: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel ride. Please try again.')),
      );
    }
    
    setState(() {
      isLoading = false;
    });
  }

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
                  controller: _otherReasonController,
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
              isLoading 
                ? CircularProgressIndicator() 
                : GestureDetector(
                    onTap: cancelRide,
                    child: getContainer(context, 'Submit')
                  )
            ],
          ),
        )),
      ),
    );
  }
}