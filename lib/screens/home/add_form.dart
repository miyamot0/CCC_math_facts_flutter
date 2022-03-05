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
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:covcopcomp_math_fact/shared/loading.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddForm extends StatefulWidget {
  const AddForm({Key key}) : super(key: key);

  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textFieldController = TextEditingController();
  String _setSizeEdit = setSizeArray[0],
      _exerciseEdit = MathFactTypes.Addition,
      _metricEdit = Metrics.Accuracy,
      _setNumber = "0",
      _preferredOrientation = Orientations.Vertical;
  bool _randomized = false, _orientationPreference = true;
  int _aimSetting;

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
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Add a New Student to Class/Group',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _textFieldController,
                  decoration: textInputDecoration.copyWith(hintText: "Student ID", labelText: "Student Name:"),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Select exercise", labelText: "Target Skill:"),
                  value: _exerciseEdit,
                  items: MathFactTypes.FactsType.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _exerciseEdit = value.toString(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Set Size", labelText: "Size of Set:"),
                  value: _setSizeEdit,
                  items: setSizeArray.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _setSizeEdit = value.toString(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Set Source", labelText: "Set Source:"),
                  value: _setNumber,
                  items: MathFactSets.AvailableSets.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _setNumber = value,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: "Select Presentation Mode", labelText: "Select Presentation Mode:"),
                  value: _preferredOrientation,
                  items: [Orientations.Vertical, Orientations.Horizontal, Orientations.NoPreference].map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) {
                    _preferredOrientation = value;
                    _orientationPreference = (value == Orientations.NoPreference) ? false : true;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: "Problem Selection", labelText: "Problem Selection:"),
                  value: _randomized ? 'Randomized' : 'Fixed',
                  items: ['Fixed', 'Randomized'].map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (value) => _randomized = value.toString() == "Randomized" ? true : false,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Primary Metric", labelText: "Primary Metric:"),
                  value: _metricEdit,
                  items: Metrics.MetricPreference.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (value) => _metricEdit = value.toString(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Aim Level", labelText: "Aim Level:"),
                  initialValue: '10',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _aimSetting = int.tryParse(value) ?? 0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(color: Colors.white)),
                  child: const Text('Add Student'),
                  onPressed: () async {
                    if (_textFieldController.text.isNotEmpty) {
                      await DatabaseService(uid: userData.uid).addToStudentCollection(Student(
                          name: _textFieldController.text,
                          set: _setNumber,
                          setSize: _setSizeEdit,
                          target: _exerciseEdit,
                          randomized: _randomized,
                          preferredOrientation: _preferredOrientation,
                          orientationPreference: _orientationPreference,
                          metric: _metricEdit,
                          aim: _aimSetting));

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
