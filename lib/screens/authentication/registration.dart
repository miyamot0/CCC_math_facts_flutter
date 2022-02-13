import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:covcopcomp_math_fact/shared/loading.dart';
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
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
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
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Name'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter your name' : null,
                        onChanged: (value) {
                          setState(() => name = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'School name'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter your school' : null,
                        onChanged: (value) {
                          setState(() => school = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Grade'),
                        validator: (value) => value.isEmpty
                            ? 'Enter the grade(s) for your classroom'
                            : null,
                        onChanged: (value) {
                          setState(() => grade = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter an email' : null,
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (value) => value.length < 6
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
                        //color: Colors.pink[400],
                        child: const Text("Register",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => {loading = true});

                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    email, pass, name, school, grade);

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
