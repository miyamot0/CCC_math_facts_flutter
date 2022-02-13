import 'package:covcopcomp_math_fact/models/usermodel.dart';
import 'package:covcopcomp_math_fact/screens/authentication/authentication.dart';
import 'package:covcopcomp_math_fact/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthRouting extends StatelessWidget {
  const AuthRouting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      return const AuthenticationPage();
    } else {
      return Home();
    }
  }
}
