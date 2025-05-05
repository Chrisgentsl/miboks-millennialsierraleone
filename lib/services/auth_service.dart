import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Re-authenticate user when needed
  Future<void> reauthenticate(String email, String password) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser?.reauthenticateWithCredential(credential);
    } catch (e) {
      throw Exception('Failed to re-authenticate: ${e.toString()}');
    }
  }

  // Refresh the auth token
  Future<void> refreshToken() async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.reload();
        await user.getIdToken(true);  // Force token refresh
      }
    } catch (e) {
      throw Exception('Failed to refresh token: ${e.toString()}');
    }
  }
}