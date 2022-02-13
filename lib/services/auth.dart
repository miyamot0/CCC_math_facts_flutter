import 'package:covcopcomp_math_fact/services/database.dart';
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
      //print(e.toString());

      return null;
    }
  }

  // Sign in with email/pass
  Future signInWithEmailAndPassword(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      User? user = result.user;

      if (user == null) {
        return null;
      } else {
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  // Register new user with email/pass
  Future registerWithEmailAndPassword(String email, String pass, String name,
      String school, String grade) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      User? user = result.user;

      if (user == null) {
        return null;
      } else {
        await DatabaseService(uid: user.uid)
            .updateTeacherData(school, name, grade, 'mathfacts', 5);

        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  // Sign out user
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }
}
