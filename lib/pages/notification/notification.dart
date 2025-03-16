import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Back Button & Title
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
                            'Notifications',
                            style: GoogleFonts.poppins(
                              color: const Color(0xff2a2a2a),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Fetch and display notifications
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(color: Colors.blue,));
                    }

                    var notifications = snapshot.data!.docs;

                    if (notifications.isEmpty) {
                      return const Center(child: Text("No notifications found"));
                    }

                    List<Widget> todayList = [];
                    List<Widget> yesterdayList = [];
                    List<Widget> earlierList = [];

                    for (var notification in notifications) {
                      var data = notification.data() as Map<String, dynamic>;

                      String title = data['title'] ?? 'No Title';
                      String body = data['body'] ?? 'No Description';
                      Timestamp timestamp =
                          data['timestamp'] ?? Timestamp.now();
                      String timeCategory = getTimeCategory(timestamp);

                      Widget notificationTile = Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff163051)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/payment.svg'),
                                ],
                              ),
                            ),
                                const SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        body,
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      if (timeCategory == "Today") {
                        todayList.add(notificationTile);
                      } else if (timeCategory == "Yesterday") {
                        yesterdayList.add(notificationTile);
                      } else {
                        earlierList.add(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeCategory, // Displays the date (e.g., "March 5, 2024")
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            notificationTile,
                          ],
                        ));
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (todayList.isNotEmpty) ...[
                          Text(
                            "Today",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...todayList,
                        ],
                        if (yesterdayList.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            "Yesterday",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...yesterdayList,
                        ],
                        if (earlierList.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          ...earlierList,
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to categorize timestamp
  String getTimeCategory(Timestamp timestamp) {
    DateTime notificationDate = timestamp.toDate();
    DateTime now = DateTime.now();

    if (notificationDate.year == now.year &&
        notificationDate.month == now.month &&
        notificationDate.day == now.day) {
      return "Today";
    } else if (notificationDate.year == now.year &&
        notificationDate.month == now.month &&
        notificationDate.day == now.day - 1) {
      return "Yesterday";
    } else {
      return "${notificationDate.day} ${_getMonthName(notificationDate.month)}, ${notificationDate.year}";
    }
  }

  // Function to get month name from month number
  String _getMonthName(int month) {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month - 1];
  }
}
