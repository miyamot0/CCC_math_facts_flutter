import 'package:covcopcomp_math_fact/screens/authenticate/register.dart';
import 'package:covcopcomp_math_fact/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  bool showSignIn = true;

  void toggleView() {
    setState(() => {showSignIn = !showSignIn});
  }

  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
