import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRoleProvider with ChangeNotifier {
  String _role = '';
  String get role => _role;

  UserRoleProvider() {
    loadRole();
  }

  Future<void> setRole(String role) async {
    _role = role;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userRole', role);
  }

  Future<void> loadRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _role = prefs.getString('userRole') ?? '';
    notifyListeners();
  }
}
