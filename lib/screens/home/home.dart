import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covcopcomp_math_fact/screens/home/settings_form.dart';
import 'package:covcopcomp_math_fact/screens/home/teacher_list.dart';
import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:provider/provider.dart';
import 'package:covcopcomp_math_fact/models/teacher.dart';

import '../../models/usermodel.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Teacher>?>.value(
      value: DatabaseService(uid: user!.uid).teachers,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Cover Copy Compare"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text("Log Out"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              onPressed: () => _showSettingsPanel(),
              label: Text("Settings"),
            )
          ],
        ),
        body: TeacherList(),
      ),
    );
  }
}
