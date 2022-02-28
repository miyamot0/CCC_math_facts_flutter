/* 
    The MIT License
    Copyright February 1, 2022 Shawn Gilroy/Louisiana State University
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/

import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:covcopcomp_math_fact/models/usermodel.dart';

import '../models/teacher.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a custom user object from response
  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // Detect auth change
  Stream<UserModel> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }

  // Sign in with email/pass
  Future signInWithEmailAndPassword(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      User user = result.user;

      return user == null ? null : _userFromFirebaseUser(user);
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

      User user = result.user;

      if (user == null) {
        return null;
      } else {
        await DatabaseService(uid: user.uid).updateTeacherInCollection(
            Teacher(school: school, name: name, grade: grade, id: user.uid));

        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  // Reset password
  Future<String> resetPassword(String email) async {
    String msg =
        "Password successfully reset. Remember to check your junk/spam folder for a link to the password change screen.";
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      msg = e.toString();
    }
    return msg;
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
