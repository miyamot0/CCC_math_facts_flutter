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

import 'package:covcopcomp_math_fact/models/student.dart';
import 'package:covcopcomp_math_fact/screens/home/settings_form.dart';
import 'package:covcopcomp_math_fact/screens/home/student_list.dart';
import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:provider/provider.dart';

import '../../models/usermodel.dart';
import '../../shared/constants.dart';

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
    final _formKey = GlobalKey<FormState>();
    String _setSizeEdit = setSizeArray[0], _exerciseEdit = factsType[0];
    bool _randomized = false;

    Future<void> _displayTextInputDialog(
        BuildContext context, String uidTag) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Enter ID for New Student'),
              content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _textFieldController,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Student ID"),
                        ),
                        DropdownButtonFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Select exercise"),
                          value: _exerciseEdit,
                          items: factsType.map((setting) {
                            return DropdownMenuItem(
                                value: setting, child: Text(setting));
                          }).toList(),
                          onChanged: (String value) =>
                              _exerciseEdit = value.toString(),
                        ),
                        DropdownButtonFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Set Size"),
                          value: _setSizeEdit,
                          items: setSizeArray.map((setting) {
                            return DropdownMenuItem(
                                value: setting, child: Text(setting));
                          }).toList(),
                          onChanged: (String value) =>
                              _setSizeEdit = value.toString(),
                        ),
                        DropdownButtonFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Set Presentation"),
                          value: _randomized ? 'Randomized' : 'Fixed',
                          items: ['Fixed', 'Randomized'].map((setting) {
                            return DropdownMenuItem(
                                value: setting, child: Text(setting));
                          }).toList(),
                          onChanged: (value) => _randomized =
                              value.toString() == "Randomized" ? true : false,
                        ),
                      ],
                    ),
                  )),
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
                      await DatabaseService(uid: uidTag).addToStudentCollection(
                          _textFieldController.text,
                          _setSizeEdit,
                          _exerciseEdit,
                          0,
                          _randomized);

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
          ],
        ),
        body: const StudentList(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await _displayTextInputDialog(context, user.uid);
          },
        ),
      ),
    );
  }
}
