import 'package:covcopcomp_math_fact/models/usermodel.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:covcopcomp_math_fact/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> settings = ['comp', 'fact'];

  // Form values
  String _currentName = '';
  String _currentTarget = '';
  int _currentSetSize = -1;
  String _currentGrade = '';
  String _currentSchool = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;

          String? currentTarget =
              _currentTarget.isEmpty ? userData?.currentTarget : 'comp';

          int currentSetSize =
              _currentSetSize < 0 ? userData!.currentSetSize : _currentSetSize;

          return Form(
            key: _formKey,
            child: Column(children: [
              Text(
                'Update your settings',
                style: const TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration,
                initialValue: userData?.name,
                validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                onChanged: (val) => setState((() => _currentName = val)),
              ),
              SizedBox(
                height: 20.0,
              ),
              DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: currentTarget,
                  items: settings.map((setting) {
                    return DropdownMenuItem(
                        value: setting, child: Text('$setting'));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _currentTarget = value.toString())),
              Slider(
                value: currentSetSize.toDouble(),
                activeColor: Colors.brown,
                inactiveColor: Colors.brown,
                min: 5,
                max: 20,
                divisions: 4,
                onChanged: (val) =>
                    setState(() => _currentSetSize = val.round()),
              ),
              RaisedButton(
                  color: Colors.pink,
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateTeacherData(
                          _currentSchool.isEmpty
                              ? userData!.currentSchool
                              : _currentSchool,
                          _currentName.isEmpty ? userData!.name : _currentName,
                          _currentGrade.isEmpty
                              ? userData!.currentGrade
                              : _currentGrade,
                          _currentTarget.isEmpty
                              ? userData!.currentTarget
                              : _currentTarget,
                          _currentSetSize < 0
                              ? userData!.currentSetSize
                              : _currentSetSize);

                      Navigator.pop(context);
                    }
                  })
            ]),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
