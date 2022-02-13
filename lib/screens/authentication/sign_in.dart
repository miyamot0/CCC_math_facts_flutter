import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:flutter/material.dart';

import '../../shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  const SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  // State for text fields
  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text('Sign in to Cover-Copy-Compare App'),
              actions: [
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text("Register"),
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    widget.toggleView!();
                  },
                )
              ],
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter an email' : null,
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (value) => value!.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => pass = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.pink[400]),
                        child: const Text("Sign in",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          var currentState = _formKey.currentState!;

                          if (currentState.validate()) {
                            setState(() => {loading = true});

                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, pass);

                            if (result == null) {
                              setState(() {
                                error =
                                    'Please double-check your email and password';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  )),
            ),
          );
  }
}
