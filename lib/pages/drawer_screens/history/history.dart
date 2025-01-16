import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                            'History',
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
                Container(
                    height: 48,
                    decoration: BoxDecoration(
                    color: const Color.fromARGB(26, 113, 153, 206),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xff0F69DB))
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: const Color(0xff5a5a5a),
                      labelStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                      indicator: BoxDecoration(
                        color: const Color(0xff0F69DB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Completed'),
                        Tab(text: 'Cancelled'),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Expanded(
                  // height: 500,
                  child: TabBarView(
                    children: [
                      _buildTabContent(),
                      _buildTabContent(),
                      _buildTabContent(),
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

  Widget _buildTabContent() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xff0F69DB)),
            ),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Row(
                  children: [
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff414141)),
                        ),
                        Text(
                          'Mustang Shelby GT',
                          style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xffb8b8b8)),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      'Today at 09:20 am',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xff414141)),
                    ),
                  ],
                ),
              ),
            ),
            // child: ListTile(
            //   title: Text(
            //     'Name',
            //     style: GoogleFonts.poppins(
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            //   subtitle: Text(
            //     'Mustang Shelby GT\nToday at 09:20 am',
            //     style: GoogleFonts.poppins(
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
          ),
        );
      },
    );
  }
}
