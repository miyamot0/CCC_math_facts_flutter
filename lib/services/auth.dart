import 'package:firebase_auth/firebase_auth.dart';
import 'package:covcopcomp_math_fact/models/usermodel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a custom user object from response
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // Detect auth change
  Stream<UserModel?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // Sign into app anonymously
  Future signInAnonymous() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      if (user == null) {
        return null;
      } else {
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  // sign in with pass

  // register with email/pass

  // Sign out user
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
