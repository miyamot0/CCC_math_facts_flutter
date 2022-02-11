import 'package:covcopcomp_math_fact/screens/authenticate/authenticate.dart';
import 'package:covcopcomp_math_fact/screens/home/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return home or auth
    return Authenticate();
  }
}
