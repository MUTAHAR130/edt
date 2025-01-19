import 'package:flutter/material.dart';

class DriverDetailsProvider extends ChangeNotifier {
  bool _isAccepted = false;
  bool _goToA = false;
  bool _goToB = false;
  bool _isArrived = false;
  bool _isFinished = false;

  bool get isAccepted => _isAccepted;
  bool get goToA => _goToA;
  bool get goToB => _goToB;
  bool get isArrived => _isArrived;
  bool get isFinished => _isFinished;

  void toggleAccepted() {
    _isAccepted = !_isAccepted;
    notifyListeners();
  }
  void toggleGoToA() {
    _goToA = !_goToA;
    notifyListeners();
  }
  void toggleGoToB() {
    _goToB = !_goToB;
    notifyListeners();
  }
  void toggleArrive() {
    _isArrived = !_isArrived;
    notifyListeners();
  }
  void toggleFinished() {
    _isFinished = !_isFinished;
    notifyListeners();
  }
}
