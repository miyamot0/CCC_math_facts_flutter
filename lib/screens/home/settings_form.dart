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

import 'package:covcopcomp_math_fact/models/teacher.dart';
import 'package:covcopcomp_math_fact/models/usermodel.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:covcopcomp_math_fact/shared/loading.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentGrade, _currentSchool, _currentName;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Update your personal info',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "e.g., John/Jane Smith", labelText: "Name:"),
                initialValue: userData.name,
                validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                onChanged: (val) => setState((() => _currentName = val)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "e.g., K-2", labelText: "Grade(s) taught:"),
                initialValue: userData.currentGrade,
                validator: (val) => val.isEmpty ? 'Please enter a value for your grade(s)' : null,
                onChanged: (val) => setState((() => _currentGrade = val)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "e.g., Sadie Hawkins", labelText: "School name:"),
                initialValue: userData.currentSchool,
                validator: (val) => val.isEmpty ? 'Please enter a value for your school' : null,
                onChanged: (val) => setState((() => _currentSchool = val)),
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(color: Colors.white)),
                  //color: Colors.pink,
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await DatabaseService(uid: user.uid).updateTeacherInCollection(Teacher(
                          school: _currentSchool ?? userData.currentSchool,
                          name: _currentName ?? userData.name,
                          grade: _currentGrade ?? userData.currentGrade,
                          id: user.uid));

                      Navigator.pop(context);
                    }
                  })
            ]),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
