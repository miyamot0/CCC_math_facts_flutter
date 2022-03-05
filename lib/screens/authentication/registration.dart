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

class Registration extends StatefulWidget {
  final Function toggleView;
  const Registration({Key key, this.toggleView}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  // State for text fields
  String name = '';
  String school = '';
  String grade = '';
  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0.0,
              title: const Text('Sign up for Cover-Copy-Compare App'),
              actions: [
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  style: TextButton.styleFrom(primary: Colors.white),
                  label: const Text("Sign In"),
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
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: AppThemes.TextInputDecoration.copyWith(hintText: 'Name', labelText: "Name:"),
                        validator: (value) => value.isEmpty ? 'Enter your name' : null,
                        onChanged: (value) {
                          setState(() => name = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            AppThemes.TextInputDecoration.copyWith(hintText: 'School name', labelText: "School Name:"),
                        validator: (value) => value.isEmpty ? 'Enter your school' : null,
                        onChanged: (value) {
                          setState(() => school = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            AppThemes.TextInputDecoration.copyWith(hintText: 'Grade', labelText: "Grade(s) Taught:"),
                        validator: (value) => value.isEmpty ? 'Enter the grade(s) for your classroom' : null,
                        onChanged: (value) {
                          setState(() => grade = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            AppThemes.TextInputDecoration.copyWith(hintText: 'Email', labelText: "Email Address:"),
                        validator: (value) => value.isEmpty ? 'Enter an email' : null,
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            AppThemes.TextInputDecoration.copyWith(hintText: 'Password', labelText: "Password:"),
                        validator: (value) => value.length < 6 ? 'Enter a password 6+ chars long' : null,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => pass = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.pink[400]),
                        //color: Colors.pink[400],
                        child: const Text("Register", style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => {loading = true});

                            dynamic result = await _auth.registerWithEmailAndPassword(email, pass, name, school, grade);

                            if (result == null) {
                              setState(() {
                                error = 'Please double-check your email and password';
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
                        style: const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ))),
            ),
          );
  }
}
