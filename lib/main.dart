// @dart=2.9
import 'package:covcopcomp_math_fact/models/usermodel.dart';
import 'package:covcopcomp_math_fact/screens/authrouting.dart';
import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
        value: AuthService().user,
        initialData: null,
        child: const MaterialApp(
          home: AuthRouting(),
        ));
  }
}
