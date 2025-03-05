import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _gender = '';
  //driver step 1
  String _driverFullname = '';
  String _driverPhone = '';
  String _driverEmail = '';
  String _driverStreet = '';
  String _driverCity = '';
  String _driverDistrict = '';
  String _driverImage = '';
  //driver step2
   String _driverVehicleName = '';
   String _driverVehicleType = '';
   String _driverVehicleNumber = '';
   String _driverVehicleColor = '';
   //driver step 3
   String _driverIdProof = '';
   String _driverDrivingLicense = '';
   String _driverVehicleRegistrationCertificate = '';
   String _driverVehiclePicture = '';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get gender => _gender;

  //driver getter 1
  String get driverFullname => _driverFullname;
  String get driverPhone => _driverPhone;
  String get driverEmail => _driverEmail;
  String get driverStreet => _driverStreet;
  String get driverCity => _driverCity;
  String get driverDistrict => _driverDistrict;
  String get driverImage => _driverImage;
  //driver getter 2
  String get driverVehicleName => _driverVehicleName;
  String get driverVehicleType => _driverVehicleType;
  String get driverVehicleNumber => _driverVehicleNumber;
  String get driverVehicleColor => _driverVehicleColor;
  //driver getter 3
  String get driverIdProof => _driverIdProof;
  String get driverDrivingLicense => _driverDrivingLicense;
  String get driverVehicleRegistrationCertificate => _driverVehicleRegistrationCertificate;
  String get driverVehiclePicture => _driverVehiclePicture;

   void setDriverImage(String imagePath) {
    _driverImage = imagePath;
    notifyListeners();
  }

  void setValues(String name, String email, String phone, String gender) {
    _name = name;
    _email = email;
    _phone = phone;
    _gender = gender;
    notifyListeners();
  }

  void setDriverValue1(
      String driverFullname,
      String driverPhone,
      String driverEmail,
      String driverStreet,
      String driverCity,
      String driverDistrict,
      String driverImage) {
    _driverFullname = driverFullname;
    _driverPhone = driverPhone;
    _driverEmail = driverEmail;
    _driverStreet = driverStreet;
    _driverCity = driverCity;
    _driverDistrict = driverDistrict;
    _driverImage = driverImage;
    notifyListeners();
  }


  void setDriverValue2(
    String driverVehicleName,
      String driverVehicleType,
      String driverVehicleNumber,
      String driverVehicleColor,
      ) {
        _driverVehicleName=driverVehicleName;
    _driverVehicleType = driverVehicleType;
    _driverVehicleNumber = driverVehicleNumber;
    _driverVehicleColor = driverVehicleColor;
    notifyListeners();
  }



  void setDriverValue3(
      String driverIdProof,
      String driverDrivingLicense,
      String driverVehicleRegistrationCertificate,
      String driverVehiclePicture,
      ) {
    _driverIdProof = driverIdProof;
    _driverDrivingLicense = driverDrivingLicense;
    _driverVehicleRegistrationCertificate = driverVehicleRegistrationCertificate;
    _driverVehiclePicture = driverVehiclePicture;
    notifyListeners();
  }
}
