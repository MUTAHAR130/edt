import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/provider/bottombar_provider.dart';
import 'package:edt/pages/bottom_bar/provider/profile_provider.dart';
import 'package:edt/pages/driver_home/driver_home.dart';
import 'package:edt/pages/expense_tracking/expense_tracking.dart';
import 'package:edt/pages/expense_tracking/provider/expense_provider.dart';
import 'package:edt/pages/home/home.dart';
import 'package:edt/pages/profile/profile.dart';
import 'package:edt/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void initState() {
    super.initState();
    String userRole =
        Provider.of<UserRoleProvider>(context, listen: false).role;

    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<PaymentProvider>(context, listen: false)
        .fetchPaymentAndExpenseData(userRole);
  });
    var userPro = Provider.of<UserRoleProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<BottomNavProvider>().setIndex(0);
    });
    if (userPro.role == 'Driver') {
      Provider.of<UserProfileProvider>(context, listen: false)
          .loadUserProfile('drivers');
    } else if (userPro.role == 'Passenger') {
      Provider.of<UserProfileProvider>(context, listen: false)
          .loadUserProfile('passengers');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var userPro = Provider.of<UserRoleProvider>(context);
    final List<Widget> _screens = [
      userPro.role == 'Passenger'
          ? HomeScreen(scaffoldKey: _scaffoldKey)
          : DriverHomeScreen(scaffoldKey: _scaffoldKey),
      ExpenseTrackingScreen(scaffoldKey: _scaffoldKey),
      ProfileScreen(scaffoldKey: _scaffoldKey),
    ];

    return Consumer<BottomNavProvider>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            return true;
            // if (model.selectedIndex == 0) {
            //   return true;
            // } else {
            //   model.setIndex(0);
            //   return false;
            // }
          },
          child: Scaffold(
            key: _scaffoldKey,
            drawer: getDrawer(context),
            body: Stack(
              children: [
                Positioned.fill(
                  child: _screens[model.selectedIndex],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, -4),
                          spreadRadius: 0.1,
                          blurRadius: 1,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildBottomNavItem(context, model,
                            'assets/icons/bottomicon1.svg', 'Home', 0),
                        _buildBottomNavItem(
                            context,
                            model,
                            'assets/icons/bottomicon2.svg',
                            userPro.role == 'Passenger'
                                ? 'Expense Tracking'
                                : 'Earning',
                            1),
                        _buildBottomNavItem(context, model,
                            'assets/icons/bottomicon3.svg', 'Profile', 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavItem(BuildContext context, BottomNavProvider model,
      String iconName, String label, int index) {
    bool isSelected = model.selectedIndex == index;
    Color iconColor = isSelected ? Color(0xff0F69DB) : Colors.black;

    return GestureDetector(
      onTap: () {
        model.setIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconName,
            color: iconColor,
            height: 24,
          ),
          Text(
            label,
            style: TextStyle(color: iconColor),
          ),
        ],
      ),
    );
  }
}
