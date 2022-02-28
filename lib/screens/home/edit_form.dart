import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';
import '../../models/usermodel.dart';
import '../../services/database.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class EditForm extends StatefulWidget {
  final String setSize;
  final String targetSkill;
  final String name;
  final String set;
  final String id;
  final bool randomized;
  final bool orientationPreference;
  final String preferredOrientation;
  final String metric;

  EditForm(
      {Key key,
      this.setSize,
      this.targetSkill,
      this.name,
      this.id,
      this.randomized,
      this.orientationPreference,
      this.preferredOrientation,
      this.metric,
      this.set})
      : super(key: key);

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textFieldController = TextEditingController();
  String _setSizeEdit,
      _exerciseEdit,
      _metricEdit,
      _preferredOrientation,
      _setNumber,
      itemPresentation;
  bool _randomized, _orientationPreference;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    _setSizeEdit = _setSizeEdit ?? widget.setSize;
    _exerciseEdit = _exerciseEdit ?? widget.targetSkill;
    _textFieldController.text = widget.name;
    _randomized = _randomized ?? widget.randomized;
    _metricEdit = _metricEdit ?? widget.metric;
    _preferredOrientation =
        _preferredOrientation ?? widget.preferredOrientation;
    _orientationPreference =
        _orientationPreference ?? widget.orientationPreference;
    _setNumber = _setNumber ?? widget.set;

    //ID is as-is

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
                  height: 20.0,
                ),
                TextField(
                  controller: _textFieldController,
                  decoration: textInputDecoration.copyWith(
                      hintText: "Student ID", labelText: "Student Name:"),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: "Select exercise", labelText: "Target Skill:"),
                  value: _exerciseEdit,
                  items: factsType.map((setting) {
                    return DropdownMenuItem(
                        value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _exerciseEdit = value.toString(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: "Set Size", labelText: "Size of Set:"),
                  value: _setSizeEdit,
                  items: setSizeArray.map((setting) {
                    return DropdownMenuItem(
                        value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _setSizeEdit = value.toString(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: "Set Source", labelText: "Set Source:"),
                  value: _setNumber,
                  items: MathFactSets().AvailableSets.map((setting) {
                    return DropdownMenuItem(
                        value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) => _setNumber = value,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: "Select Presentation Mode",
                      labelText: "Select Presentation Mode:"),
                  value: _preferredOrientation,
                  items: [
                    Orientations().Vertical,
                    Orientations().Horizontal,
                    Orientations().NoPreference
                  ].map((setting) {
                    return DropdownMenuItem(
                        value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (String value) {
                    _preferredOrientation = value;

                    _orientationPreference =
                        (value == Orientations().NoPreference) ? false : true;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: "Primary Metric", labelText: "Primary Metric:"),
                  value: _metricEdit,
                  items: metricPreference.map((setting) {
                    return DropdownMenuItem(
                        value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (value) => _metricEdit = value.toString(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: "Problem Selection",
                      labelText: "Problem Selection:"),
                  value: _randomized ? 'Randomized' : 'Fixed',
                  items: ['Fixed', 'Randomized'].map((setting) {
                    return DropdownMenuItem(
                        value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (value) => _randomized =
                      value.toString() == "Randomized" ? true : false,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blue,
                      textStyle: const TextStyle(color: Colors.white)),
                  child: const Text('Update Student'),
                  onPressed: () async {
                    if (_textFieldController.text.isNotEmpty) {
                      await DatabaseService(uid: userData.uid)
                          .updateStudentInCollection(Student(
                              id: widget.id,
                              name: _textFieldController.text,
                              set: _setNumber,
                              setSize: _setSizeEdit,
                              target: _exerciseEdit,
                              randomized: _randomized,
                              preferredOrientation: _preferredOrientation,
                              orientationPreference: _orientationPreference,
                              metric: _metricEdit));

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
