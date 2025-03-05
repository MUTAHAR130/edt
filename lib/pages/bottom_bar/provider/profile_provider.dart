import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProfileProvider with ChangeNotifier {
  String uid = '';
  String username = '';
  String email = '';
  String phone = '';
  String city = '';
  String profileImage = '';

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadUserProfile(String collectionName) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        username = data['fullname'] ?? data['username'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        city = data['city'] ?? '';
        profileImage = data.containsKey('driverImage')
            ? data['driverImage']
            : data.containsKey('passengerImage')
                ? data['passengerImage']
                : '';
      }
      _isLoaded = true;
      notifyListeners();
    }
  }

  void updateProfile({
    String? username,
    String? email,
    String? phone,
    String? city,
    String? profileImage,
  }) {
    if (username != null) this.username = username;
    if (email != null) this.email = email;
    if (phone != null) this.phone = phone;
    if (city != null) this.city = city;
    if (profileImage != null) this.profileImage = profileImage;
    notifyListeners();
  }
}
