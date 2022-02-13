import 'package:covcopcomp_math_fact/models/usermodel.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:covcopcomp_math_fact/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> settings = ['Math Facts', 'Computation'];

  // Form values
  String _currentGrade;
  String _currentSchool;
  String _currentName;

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
              const Text(
                'Update your personal info',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Your name"),
                initialValue: userData.name,
                validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                onChanged: (val) => setState((() => _currentName = val)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: "Grade(s) taught"),
                initialValue: userData.currentGrade,
                validator: (val) => val.isEmpty
                    ? 'Please enter a value for your grade(s)'
                    : null,
                onChanged: (val) => setState((() => _currentGrade = val)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: "School name"),
                initialValue: userData.currentSchool,
                validator: (val) =>
                    val.isEmpty ? 'Please enter a value for your school' : null,
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
                      await DatabaseService(uid: user.uid).updateTeacherData(
                          _currentSchool ?? userData.currentSchool,
                          _currentName ?? userData.name,
                          _currentGrade ?? userData.currentGrade);

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
