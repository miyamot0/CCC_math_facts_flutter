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
      _orientationSetting,
      itemPresentation;
  bool _randomized, _preference;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    _setSizeEdit = _setSizeEdit ?? widget.setSize;
    _exerciseEdit = _exerciseEdit ?? widget.targetSkill;
    _textFieldController.text = widget.name;
    _randomized = widget.randomized;
    _metricEdit = widget.metric;

    // TODO: add in
    _preferredOrientation = widget.preferredOrientation;

    // TODO: set number
    _setNumber = widget.set;

    // TODO: orientation
    _orientationSetting = widget.preferredOrientation;

    // TODO: set item presentation (i.e.,  random)
    _preference = widget.orientationPreference;

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

                // TODO: set number

                // TODO: orientation

                // TODO: set item presentation (i.e.,  random)

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
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(color: Colors.white)),
                  child: const Text('Update Student'),
                  onPressed: () async {
                    if (_textFieldController.text.isNotEmpty) {
                      await DatabaseService(uid: userData.uid)
                          .addToStudentCollection(Student(
                              name: _textFieldController.text,
                              set: "0",
                              setSize: _setSizeEdit,
                              target: _exerciseEdit,
                              randomized: _randomized,
                              preferredOrientation: "Horizontal",
                              orientationPreference: false,
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
