import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _gender = '';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get gender => _gender;

  void setValues(String name,String email,String phone,String gender) {
    _name = name;
    _email = email;
    _phone = phone;
    _gender = gender;
    notifyListeners();
  }

}
