import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  // State for text fields
  String email = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign in to App'),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Register"),
            onPressed: () {
              widget.toggleView!();
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
            child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                setState(() => email = value);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              onChanged: (value) {
                setState(() => pass = value);
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.pink[400],
              child: Text("Sign in", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                print(email);
                print(pass);
              },
            )
          ],
        )),
      ),
    );
  }
}
