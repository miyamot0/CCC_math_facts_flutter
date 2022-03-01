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
import 'package:covcopcomp_math_fact/models/usermodel.dart';
import 'package:covcopcomp_math_fact/screens/home/add_form.dart';
import 'package:covcopcomp_math_fact/screens/home/help_widget.dart';
import 'package:covcopcomp_math_fact/screens/home/settings_form.dart';
import 'package:covcopcomp_math_fact/screens/home/student_list.dart';
import 'package:covcopcomp_math_fact/services/auth.dart';
import 'package:covcopcomp_math_fact/services/database.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    void _showHelpPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(left: 60.0, right: 60.0, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const HelpWidget(),
            ));
          });
    }

    // Render bottom modal sheet
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(left: 60.0, right: 60.0, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const SettingsForm(),
            ));
          });
    }

    // Render bottom modal sheet
    void _addParticipantModal() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(left: 60.0, right: 60.0, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const AddForm(),
            ));
          });
    }

    return StreamProvider<List<Student>>.value(
      value: DatabaseService(uid: user.uid).students,
      initialData: null,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text("List of current students:"),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            FloatingActionButton(
              child: const Icon(Icons.help),
              backgroundColor: Colors.redAccent,
              onPressed: () => _showHelpPanel(),
            ),
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _addParticipantModal(),
            )
          ]),
        ),
      ),
    );
  }
}
