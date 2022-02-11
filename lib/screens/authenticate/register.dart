import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // State for text fields
  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign up for App'),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign In"),
            onPressed: () {
              widget.toggleView!();
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
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter an email' : null,
                  onChanged: (value) {
                    setState(() => email = value);
                  },
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                RaisedButton(
                  color: Colors.pink[400],
                  child:
                      Text("Register", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    var currentState = _formKey.currentState!;

                    if (currentState.validate()) {
                      dynamic result =
                          await _auth.registerWithEmailAndPassword(email, pass);

                      if (result == null) {
                        setState(() => {
                              error =
                                  'Please double-check your email and password'
                            });
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            )),
      ),
    );
  }
}
