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
  String _currentGrade = '';
  String _currentSchool = '';
  int _currentSetSize = -1;
  String _currentTarget = '';
  String _currentName = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;

          // TODO: add in extra spots

          /*

          String? currentTarget =
              _currentTarget.isEmpty ? userData?.currentTarget : 'comp';

          int currentSetSize =
              _currentSetSize < 0 ? userData!.currentSetSize : _currentSetSize;
          */
          return Form(
            key: _formKey,
            child: Column(children: [
              const Text(
                'Update your settings',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration,
                initialValue: userData.name,
                validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                onChanged: (val) => setState((() => _currentName = val)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentTarget ?? userData.currentTarget,
                  items: settings.map((setting) {
                    return DropdownMenuItem(
                        value: setting, child: Text(setting));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _currentTarget = value.toString())),
              Slider(
                value: (_currentSetSize ?? userData.currentSetSize).toDouble(),
                activeColor: Colors.brown,
                inactiveColor: Colors.brown,
                min: 5,
                max: 20,
                divisions: 4,
                onChanged: (val) =>
                    setState(() => _currentSetSize = val.round()),
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
                          _currentGrade ?? userData.currentGrade,
                          _currentTarget ?? userData.currentTarget,
                          _currentSetSize ?? userData.currentSetSize);

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
