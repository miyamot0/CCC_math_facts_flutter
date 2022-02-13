import 'package:covcopcomp_math_fact/screens/authentication/registration.dart';
import 'package:covcopcomp_math_fact/screens/authentication/sign_in.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  __AuthenticationPageState createState() => __AuthenticationPageState();
}

class __AuthenticationPageState extends State<AuthenticationPage> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => {showSignIn = !showSignIn});
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Registration(toggleView: toggleView);
    }
  }
}
