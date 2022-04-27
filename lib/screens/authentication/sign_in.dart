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

import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:covcopcomp_math_fact/shared/loading.dart';
import 'package:covcopcomp_math_fact/shared/themes.dart';

import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key key, this.toggleView}) : super(key: key);

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

  static const sizedBox10 = SizedBox(height: 10);
  static const sizedBox20 = SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0.0,
              title: const Text('Sign in to Cover-Copy-Compare App'),
              actions: [
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text("Register"),
                  style: AppThemes.AppBarButtonStyle,
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      sizedBox10,
                      const Text("Sign In Page", style: AppThemes.PrimaryTextStyle),
                      sizedBox20,
                      TextFormField(
                        decoration: AppThemes.TextInputDecoration.copyWith(
                            hintText: 'jane@email.com', labelText: "Email Address:"),
                        validator: (value) => value.isEmpty ? 'Enter an email' : null,
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                      ),
                      sizedBox20,
                      TextFormField(
                        decoration: AppThemes.TextInputDecoration.copyWith(labelText: "Password:"),
                        validator: (value) => value.length < 6 ? 'Enter a password 6+ chars long' : null,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => pass = value);
                        },
                      ),
                      sizedBox20,
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: AppThemes.PrimaryButtonStyle,
                              child: const Text("Sign in", style: AppThemes.PrimaryButtonTextStyle),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => {loading = true});

                                  dynamic result = await _auth.signInWithEmailAndPassword(email, pass);

                                  if (result == null) {
                                    setState(() {
                                      error = 'Please double-check your email and password';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                            ),
                            sizedBox20,
                            ElevatedButton(
                              style: AppThemes.SecondaryButtonStyle,
                              child: const Text("Forgot Password?", style: AppThemes.SecondaryButtonTextStyle),
                              onPressed: () async {
                                String msg = await _auth.resetPassword(email);

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Password Reset"),
                                        content: Text(msg),
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                      sizedBox10,
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  )),
            ),
          );
  }
}
