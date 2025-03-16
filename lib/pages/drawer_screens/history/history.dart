import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildTabBar(),
                const SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    children: [
                      // _buildHistoryList('upcoming',context),
                      _buildHistoryList('completed',context),
                      _buildHistoryList('cancelled',context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios, size: 24, color: Color(0xff414141)),
                  Text('Back',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff414141))),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Text('History',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff2a2a2a))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color.fromARGB(26, 113, 153, 206),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff0F69DB)),
        ),
        child: TabBar(
          labelColor: Colors.white,
          dividerColor: Colors.transparent,
          unselectedLabelColor: const Color(0xff5a5a5a),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          indicator: BoxDecoration(
            color: const Color(0xff0F69DB),
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            // Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(String status,context) { 
    var roleProvider=Provider.of<UserRoleProvider>(context);
      String role = roleProvider.role;
      String collectionName = role == 'Driver' ? 'drivers' : 'passengers';
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text("User not logged in"));

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        String userRole = snapshot.data?['role'] ?? 'Passenger';
        String uidField = userRole == 'Driver' ? 'driverUid' : 'passengerUid';

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('history')
              .where('role', isEqualTo: userRole)
              .where('status', isEqualTo: status)
              .where(uidField, isEqualTo: user.uid)
              .snapshots(),
          builder: (context, historySnapshot) {
            if (!historySnapshot.hasData) return const Center(child: CircularProgressIndicator());

            var historyDocs = historySnapshot.data!.docs;
            if (historyDocs.isEmpty) {
              return const Center(
                child: Text(
                  'No history available',
                  style: TextStyle(fontSize: 16, color: Color(0xff5a5a5a)),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: historyDocs.length,
              itemBuilder: (context, index) {
                var data = historyDocs[index];
                return _buildHistoryTile(data);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryTile(QueryDocumentSnapshot data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0,left: 20,right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff0F69DB)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle Name',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xff414141)),
                  ),
                  Text(
                    data['vehicleName'] ?? 'Unknown',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xffb8b8b8)),
                  ),
                ],
              ),
              Spacer(),
              Text(
                'USD \$${data['price']}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff414141)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
