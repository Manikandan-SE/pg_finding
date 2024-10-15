import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  AuthServices._();
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Abort if the user cancels the sign-in
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final signInCredentials =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return signInCredentials;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
    } on Exception catch (e) {
      print('Exception firebase: $e');
    }
    return null;
  }

  static Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during sign-out: ${e.message}');
      return false;
    } on Exception catch (e) {
      print('Exception during sign-out: $e');
      return false;
    }
  }
}
