import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // anon
  Future signInAnonymous() async {
    try {
      UserCredential result = await _auth.signInAnonymously();

      User? user = result.user;

      return user;
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  // sign in with pass

  // register with email/pass

  // sign out
}
