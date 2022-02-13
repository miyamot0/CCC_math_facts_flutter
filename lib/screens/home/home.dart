import 'package:covcopcomp_math_fact/screens/home/student_list.dart';
import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/usermodel.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    /*
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const SettingsForm(),
            );
          });
    }
    */

    return StreamProvider<List<String>?>.value(
      value: DatabaseService(uid: user!.uid).students,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text("List of current students:"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person),
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () async {
                await _auth.signOut();
              },
              label: const Text("Log Out"),
            ),
            //TextButton.icon(
            //  icon: const Icon(Icons.settings),
            //  style: TextButton.styleFrom(primary: Colors.white),
            //  onPressed: () => _showSettingsPanel(),
            //  label: const Text("Settings"),
            //),
            TextButton.icon(
              icon: const Icon(Icons.settings),
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () async {
                await DatabaseService(uid: user.uid)
                    .addStudentToClassroom('temp');
                DatabaseService(uid: user.uid).readStudents();
              },
              label: const Text("Add Student"),
            )
          ],
        ),
        body: const StudentList(),
      ),
    );
  }
}
