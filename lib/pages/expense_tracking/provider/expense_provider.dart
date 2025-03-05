import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetail {
  final String name;
  final String imageUrl;
  final Timestamp verifiedAt;
  final String amount;

  PaymentDetail({
    required this.name, 
    required this.imageUrl, 
    required this.verifiedAt, 
    required this.amount
  });
  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
    'verifiedAt': verifiedAt.millisecondsSinceEpoch,
    'amount': amount
  };

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
    name: json['name'],
    imageUrl: json['imageUrl'],
    verifiedAt: Timestamp.fromMillisecondsSinceEpoch(json['verifiedAt']),
    amount: json['amount']
  );
}

class PaymentProvider with ChangeNotifier {
  double _totalAmount = 0.0;
  int _totalDeliveries = 0;
  List<PaymentDetail> _paymentDetails = [];
  bool _isLoading = false;
  String? _error;

  
  double get totalAmount => _totalAmount;
  int get totalDeliveries => _totalDeliveries;
  List<PaymentDetail> get paymentDetails => _paymentDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PaymentProvider() {
    
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    
    _totalAmount = prefs.getDouble('totalAmount') ?? 0.0;
    
    
    _totalDeliveries = prefs.getInt('totalDeliveries') ?? 0;
    
    
    List<String>? cachedPaymentDetails = prefs.getStringList('paymentDetails');
    if (cachedPaymentDetails != null) {
      _paymentDetails = cachedPaymentDetails
          .map((jsonString) => PaymentDetail.fromJson(jsonDecode(jsonString)))
          .toList();
    }

    notifyListeners();
  }

  Future<void> _saveCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    
    await prefs.setDouble('totalAmount', _totalAmount);
    
    
    await prefs.setInt('totalDeliveries', _totalDeliveries);
    
    
    List<String> paymentDetailsJson = _paymentDetails
        .map((detail) => jsonEncode(detail.toJson()))
        .toList();
    await prefs.setStringList('paymentDetails', paymentDetailsJson);
  }

  Future<void> fetchPaymentAndExpenseData(String role) async {
    try {
      
      _isLoading = true;
      _error = null;
      notifyListeners();

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _isLoading = false;
        _error = 'No user logged in';
        notifyListeners();
        return;
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      
      await _fetchTotalAmount(currentUser, role, firestore);

      
      await _fetchPaymentDetails(currentUser, role, firestore);

      
      await _saveCachedData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      print('Error in fetchPaymentAndExpenseData: $e');
    }
  }

  Future<void> _fetchTotalAmount(
    User currentUser, 
    String role, 
    FirebaseFirestore firestore
  ) async {
    DocumentSnapshot userDoc;
    if (role == 'Passenger') {
      userDoc = await firestore
          .collection('passengers')
          .doc(currentUser.uid)
          .get();

      _totalAmount = (userDoc.data() as Map<String, dynamic>?)?['totalExpense']?.toDouble() ?? 0.0;
    } else if (role == 'Driver') {
      userDoc = await firestore
          .collection('drivers')
          .doc(currentUser.uid)
          .get();

      _totalAmount = (userDoc.data() as Map<String, dynamic>?)?['totalEarnings']?.toDouble() ?? 0.0;
      _totalDeliveries = (userDoc.data() as Map<String, dynamic>?)?['totalDeliveries'] ?? 0;
    }
  }

  Future<void> _fetchPaymentDetails(
    User currentUser, 
    String role, 
    FirebaseFirestore firestore
  ) async {
    QuerySnapshot paymentsSnapshot;
    List<PaymentDetail> details = [];

    if (role == 'Passenger') {
      
      paymentsSnapshot = await firestore
          .collection('payments')
          .where('passengerId', isEqualTo: currentUser.uid)
          .get();

      for (var paymentDoc in paymentsSnapshot.docs) {
        var paymentData = paymentDoc.data() as Map<String, dynamic>;
        
        
        var driverDoc = await firestore
            .collection('drivers')
            .doc(paymentData['driverId'])
            .get();
        
        details.add(PaymentDetail(
          name: driverDoc['fullname'] ?? 'Unknown Driver',
          imageUrl: driverDoc['driverImage'] ?? '',
          verifiedAt: paymentData['verifiedAt'],
          amount: paymentData['amount']?? '0.0'
        ));
      }
    } else if (role == 'Driver') {
      paymentsSnapshot = await firestore
          .collection('payments')
          .where('driverId', isEqualTo: currentUser.uid)
          .get();

      for (var paymentDoc in paymentsSnapshot.docs) {
        var paymentData = paymentDoc.data() as Map<String, dynamic>;
        
        var passengerDoc = await firestore
            .collection('passengers')
            .doc(paymentData['passengerId'])
            .get();
        
        details.add(PaymentDetail(
          name: passengerDoc['username'] ?? 'Unknown Passenger',
          imageUrl: passengerDoc['passengerImage'] ?? '',
          verifiedAt: paymentData['verifiedAt'],
          amount: paymentData['amount']?? '0.0'
        ));
      }
    }

    _paymentDetails = details;
  }

  
  void reset() {
    _totalAmount = 0.0;
    _totalDeliveries = 0;
    _paymentDetails = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}