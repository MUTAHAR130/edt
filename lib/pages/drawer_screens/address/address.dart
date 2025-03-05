import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/drawer_screens/address/widget/address_sheet.dart';
import 'package:edt/widgets/container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: SafeArea(
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
                          const Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: Color(0xff414141),
                          ),
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
                          'Address',
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
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('addresses')
                      .where('uid', isEqualTo: uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No address added",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    var addresses = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        var address = addresses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/address_loc.svg'),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            address['addressName'],
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: const Color(0xff414141),
                                            ),
                                          ),
                                          Text(
                                            address['addressDetails'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: const Color(0xffb8b8b8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addressSheet(context,
                                            isEditing: true,
                                            addressId: address.id,
                                            addressName: address['addressName'],
                                            addressDetails:
                                                address['addressDetails']);
                                      },
                                      child: SvgPicture.asset(
                                          'assets/icons/address_icon.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  addressSheet(context);
                },
                child: getContainer(context, 'Add New Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
