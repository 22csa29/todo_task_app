import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Your actual Web Client ID from Firebase
  static const String webClientId = '284333516629-26eveo7g4stgmprp99r1bakecpcm6old.apps.googleusercontent.com';

  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // ✅ Web Google Sign-In
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
          ..addScope('email')
          ..setCustomParameters({'login_hint': 'user@example.com'});

        final UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        // ✅ Mobile Google Sign-In
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: webClientId, // Optional on Android, required on iOS
        );

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print("❌ Google Sign-In failed: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      await GoogleSignIn().signOut();
    }
  }
}
