import 'package:covcopcomp_math_fact/models/student.dart';
import 'package:covcopcomp_math_fact/screens/home/settings_form.dart';
import 'package:covcopcomp_math_fact/screens/home/student_list.dart';
import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/usermodel.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    TextEditingController _textFieldController = TextEditingController();

    Future<void> _displayTextInputDialog(
        BuildContext context, String uidTag) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Enter ID for New Student'),
              content: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: "Tag Here"),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(color: Colors.white)),
                  child: const Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(color: Colors.white)),
                  child: const Text('Add Student'),
                  onPressed: () async {
                    if (_textFieldController.text.isNotEmpty) {
                      await DatabaseService(uid: uidTag)
                          .addToStudentCollection(_textFieldController.text);

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          });
    }

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

    return StreamProvider<List<Student>>.value(
      value: DatabaseService(uid: user.uid).students,
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
            TextButton.icon(
              icon: const Icon(Icons.settings),
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () => _showSettingsPanel(),
              label: const Text("Settings"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () async {
                await _displayTextInputDialog(context, user.uid);
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
