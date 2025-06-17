// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendSignInLink(String email) async {
    final acs = ActionCodeSettings(
      url: 'https://klyro-casyca.project.sojolink.com/login', // updated dynamic link host
      handleCodeInApp: true,
      androidPackageName: 'com.example.test_flutter',
      androidInstallApp: true,
      androidMinimumVersion: '7',
      iOSBundleId: 'com.example.testFlutter',
    );

    await _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: acs,
    );
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailForSignIn', email);
  }

  Future<UserCredential?> signInWithLink(String link) async {
    if (!_auth.isSignInWithEmailLink(link)) return null;
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('emailForSignIn');
    if (email == null) return null;
    final cred = await _auth.signInWithEmailLink(
      email: email,
      emailLink: link,
    );
    await prefs.remove('emailForSignIn');
    return cred;
  }
}