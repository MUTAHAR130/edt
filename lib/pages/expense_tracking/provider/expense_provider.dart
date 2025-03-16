import 'dart:async';
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

  PaymentDetail(
      {required this.name,
      required this.imageUrl,
      required this.verifiedAt,
      required this.amount});

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
      amount: json['amount']);
}

class PaymentProvider with ChangeNotifier {
  double _totalAmount = 0.0;
  int _totalDeliveries = 0;
  List<PaymentDetail> _paymentDetails = [];
  bool _isLoading = false;
  String? _error;
  bool _needsRefresh = false;
  DateTime? _lastFetchTime;
  final Duration _cacheValidDuration = Duration(hours: 1);

  double get totalAmount => _totalAmount;
  int get totalDeliveries => _totalDeliveries;
  List<PaymentDetail> get paymentDetails => _paymentDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get needsRefresh =>
      _needsRefresh ||
      (_lastFetchTime == null ||
          DateTime.now().difference(_lastFetchTime!) > _cacheValidDuration);

  StreamSubscription? _paymentSubscription;

  PaymentProvider() {
    _loadCachedData();
  }

  @override
  void dispose() {
    _paymentSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load last fetch time
      final lastFetchMillis = prefs.getInt('lastFetchTime');
      if (lastFetchMillis != null) {
        _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetchMillis);
      }

      // Load total amount
      _totalAmount = prefs.getDouble('totalAmount') ?? 0.0;

      // Load total deliveries
      _totalDeliveries = prefs.getInt('totalDeliveries') ?? 0;

      // Load payment details
      List<String>? cachedPaymentDetails =
          prefs.getStringList('paymentDetails');
      if (cachedPaymentDetails != null && cachedPaymentDetails.isNotEmpty) {
        _paymentDetails = cachedPaymentDetails
            .map((jsonString) => PaymentDetail.fromJson(jsonDecode(jsonString)))
            .toList();
      }

      notifyListeners();
    } catch (e) {
      print('Error loading cached data: $e');
    }
  }

  Future<void> _saveCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save last fetch time
      _lastFetchTime = DateTime.now();
      await prefs.setInt(
          'lastFetchTime', _lastFetchTime!.millisecondsSinceEpoch);

      // Save total amount
      await prefs.setDouble('totalAmount', _totalAmount);

      // Save total deliveries
      await prefs.setInt('totalDeliveries', _totalDeliveries);

      // Save payment details
      List<String> paymentDetailsJson =
          _paymentDetails.map((detail) => jsonEncode(detail.toJson())).toList();
      await prefs.setStringList('paymentDetails', paymentDetailsJson);
    } catch (e) {
      print('Error saving cached data: $e');
    }
  }

  Future<void> fetchPaymentAndExpenseData(String role) async {
    try {
      // Set loading state
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

      // Fetch total amount data
      await _fetchTotalAmount(currentUser, role, firestore);

      // Fetch payment details
      _fetchPaymentDetails(currentUser, role, firestore);

      // Reset refresh flag
      _needsRefresh = false;

      // Save to cache
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
      User currentUser, String role, FirebaseFirestore firestore) async {
    try {
      DocumentSnapshot userDoc;

      if (role == 'Passenger') {
        // Set up real-time listener for passenger data
        _setupPassengerDataListener(currentUser.uid, firestore);

        // Get initial data
        userDoc =
            await firestore.collection('passengers').doc(currentUser.uid).get();

        if (userDoc.exists) {
          _totalAmount =
              (userDoc.data() as Map<String, dynamic>?)?['totalExpense']
                      ?.toDouble() ??
                  0.0;
        }
      } else if (role == 'Driver') {
        // Set up real-time listener for driver data
        _setupDriverDataListener(currentUser.uid, firestore);

        // Get initial data
        userDoc =
            await firestore.collection('drivers').doc(currentUser.uid).get();

        if (userDoc.exists) {
          _totalAmount =
              (userDoc.data() as Map<String, dynamic>?)?['totalEarnings']
                      ?.toDouble() ??
                  0.0;
          _totalDeliveries =
              (userDoc.data() as Map<String, dynamic>?)?['totalDeliveries'] ??
                  0;
        }
      }
    } catch (e) {
      print('Error fetching total amount: $e');
      throw e;
    }
  }

  StreamSubscription? _userDataSubscription;

  void _setupPassengerDataListener(String userId, FirebaseFirestore firestore) {
    _userDataSubscription?.cancel();

    _userDataSubscription = firestore
        .collection('passengers')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          _totalAmount = data['totalExpense']?.toDouble() ?? 0.0;
          notifyListeners();
          _saveCachedData();
        }
      }
    }, onError: (e) {
      print('Error in passenger data listener: $e');
    });
  }

  void _setupDriverDataListener(String userId, FirebaseFirestore firestore) {
    _userDataSubscription?.cancel();

    _userDataSubscription = firestore
        .collection('drivers')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          _totalAmount = data['totalEarnings']?.toDouble() ?? 0.0;
          _totalDeliveries = data['totalDeliveries'] ?? 0;
          notifyListeners();
          _saveCachedData();
        }
      }
    }, onError: (e) {
      print('Error in driver data listener: $e');
    });
  }

  void _fetchPaymentDetails(
      User currentUser, String role, FirebaseFirestore firestore) {
    _paymentSubscription?.cancel();

    Query query;

    if (role == 'Passenger') {
      query = firestore
          .collection('payments')
          .where('passengerId', isEqualTo: currentUser.uid)
          .orderBy('verifiedAt', descending: true);
    } else {
      query = firestore
          .collection('payments')
          .where('driverId', isEqualTo: currentUser.uid)
          .orderBy('verifiedAt', descending: true);
    }

    _paymentSubscription = query.snapshots().listen((paymentsSnapshot) async {
      List<PaymentDetail> details = [];

      for (var paymentDoc in paymentsSnapshot.docs) {
        var paymentData = paymentDoc.data() as Map<String, dynamic>;

        try {
          DocumentSnapshot userDoc;
          String userId;
          String imageField;

          if (role == 'Passenger') {
            userId = paymentData['driverId'];
            imageField = 'driverImage';
            userDoc = await firestore.collection('drivers').doc(userId).get();
          } else {
            userId = paymentData['passengerId'];
            imageField = 'passengerImage';
            userDoc =
                await firestore.collection('passengers').doc(userId).get();
          }

          if (userDoc.exists) {
            // Safely access document data
            Map<String, dynamic> userData =
                userDoc.data() as Map<String, dynamic>;

            // Determine user name based on available fields
            String userName = 'Unknown User';
            if (userData.containsKey('fullname')) {
              userName = userData['fullname'] ?? 'Unknown User';
            } else if (userData.containsKey('username')) {
              userName = userData['username'] ?? 'Unknown User';
            }

            // Safely get image URL
            String imageUrl = '';
            if (userData.containsKey(imageField)) {
              imageUrl = userData[imageField] ?? '';
            }

            details.add(PaymentDetail(
                name: userName,
                imageUrl: imageUrl,
                verifiedAt: paymentData['verifiedAt'],
                amount: paymentData['amount'] ?? '0.0'));
          }
        } catch (e) {
          print('Error processing payment document: $e');
        }
      }

      details.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

      _paymentDetails = details;
      _isLoading = false;
      notifyListeners();

      // Save updated data to cache
      _saveCachedData();
    }, onError: (e) {
      print('Error in payment details listener: $e');
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    });
  }

  void markForRefresh() {
    _needsRefresh = true;
  }

  void reset() {
    _totalAmount = 0.0;
    _totalDeliveries = 0;
    _paymentDetails = [];
    _isLoading = false;
    _error = null;
    _needsRefresh = true;
    _paymentSubscription?.cancel();
    _userDataSubscription?.cancel();
    notifyListeners();
  }
}
