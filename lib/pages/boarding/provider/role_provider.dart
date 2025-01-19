import 'package:flutter/foundation.dart';

class UserRoleProvider with ChangeNotifier {
  String _role = '';

  String get role => _role;

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }
}
