import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginUser(String emailOrPhone, String password) async {
    try {
      if (emailOrPhone.contains('@')) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailOrPhone,
          password: password,
        );
        return userCredential.user;
      } else {
        throw Exception("Phone number login is not supported in this example.");
      }
    } catch (e) {
      throw Exception("Failed to login: $e");
    }
  }
}
