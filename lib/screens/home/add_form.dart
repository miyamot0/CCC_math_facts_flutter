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
import 'package:covcopcomp_math_fact/shared/themes.dart';

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
      _errFeedback = ErrorFeedback.EachTrialAlways;
  bool _randomized = false;
  int _aimSetting;
  List<String> setOptions;

  static const sizedBox10 = SizedBox(height: 10);
  static const sizedBox20 = SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    setOptions = getSetOptions(_exerciseEdit);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                sizedBox10,
                const Text(
                  'Add a New Student to Class/Group',
                  style: TextStyle(fontSize: 18.0),
                ),
                sizedBox20,
                TextField(
                  controller: _textFieldController,
                  decoration:
                      AppThemes.TextInputDecoration.copyWith(hintText: "Student ID", labelText: "Student Name:"),
                ),
                sizedBox20,
                DropdownButtonFormField(
                  decoration:
                      AppThemes.TextInputDecoration.copyWith(hintText: "Select exercise", labelText: "Target Skill:"),
                  value: _exerciseEdit,
                  items: MathFactTypes.FactsType.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _exerciseEdit = value.toString(),
                ),
                sizedBox20,
                DropdownButtonFormField(
                  decoration: AppThemes.TextInputDecoration.copyWith(hintText: "Set Size", labelText: "Size of Set:"),
                  value: _setSizeEdit,
                  items: setSizeArray.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _setSizeEdit = value.toString(),
                ),
                sizedBox20,
                DropdownButtonFormField(
                  decoration: AppThemes.TextInputDecoration.copyWith(hintText: "Set Source", labelText: "Set Source:"),
                  value: _setNumber,
                  items: setOptions.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _setNumber = value,
                ),
                sizedBox20,
                DropdownButtonFormField(
                  decoration: AppThemes.TextInputDecoration.copyWith(
                      hintText: "Problem Selection", labelText: "Problem Selection:"),
                  value: _randomized ? 'Randomized' : 'Fixed',
                  items: ['Fixed', 'Randomized'].map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (value) => _randomized = value.toString() == "Randomized" ? true : false,
                ),
                sizedBox20,
                DropdownButtonFormField(
                  decoration:
                      AppThemes.TextInputDecoration.copyWith(hintText: "Primary Metric", labelText: "Primary Metric:"),
                  value: _metricEdit,
                  items: Metrics.MetricPreference.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (value) => _metricEdit = value.toString(),
                ),
                sizedBox20,
                DropdownButtonFormField(
                  decoration:
                      AppThemes.TextInputDecoration.copyWith(hintText: "Error Feedback", labelText: "Error Feedback:"),
                  value: _errFeedback,
                  items: ErrorFeedback.FeedbackOptions.map((setting) {
                    return DropdownMenuItem(value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (value) => _errFeedback = value.toString(),
                ),
                sizedBox20,
                TextFormField(
                  decoration: AppThemes.TextInputDecoration.copyWith(hintText: "Aim Level", labelText: "Aim Level:"),
                  initialValue: '10',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _aimSetting = int.tryParse(value) ?? 0,
                ),
                sizedBox20,
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
                          metric: _metricEdit,
                          errorFeedback: _errFeedback,
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
