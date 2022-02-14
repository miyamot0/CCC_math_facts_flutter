import 'package:covcopcomp_math_fact/models/student.dart';
import 'package:covcopcomp_math_fact/screens/mathfacts/mathfacts_ccc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/usermodel.dart';
import '../../services/database.dart';
import '../../shared/constants.dart';

class StudentTile extends StatefulWidget {
  final Student student;

  const StudentTile({Key key, this.student}) : super(key: key);

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    TextEditingController _textFieldController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    Future<void> _displayTextModificationDialog(
        BuildContext context,
        String _setSizeEdit,
        String _exerciseEdit,
        String _name,
        String _id) async {
      _textFieldController.text = _name;

      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Update Student Information'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _textFieldController,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Student ID"),
                    ),
                    DropdownButtonFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Select exercise"),
                      value: _exerciseEdit,
                      items: ["Math Facts", "Computation"].map((setting) {
                        return DropdownMenuItem(
                            value: setting, child: Text(setting));
                      }).toList(),
                      onChanged: (String value) =>
                          _exerciseEdit = value.toString(),
                    ),
                    DropdownButtonFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Set Size"),
                      value: _setSizeEdit,
                      items: ["5", "10", "20"].map((setting) {
                        return DropdownMenuItem(
                            value: setting, child: Text(setting));
                      }).toList(),
                      onChanged: (String value) =>
                          _setSizeEdit = value.toString(),
                    ),
                  ],
                ),
              ),
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
                  child: const Text('Update Student'),
                  onPressed: () async {
                    if (_textFieldController.text.isNotEmpty) {
                      await DatabaseService(uid: user.uid)
                          .updateStudentInCollection(_textFieldController.text,
                              _setSizeEdit, _exerciseEdit, _id);

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: GestureDetector(
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.green[100],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MathFactsCCC(student: widget.student)),
              );
            },
            onLongPress: () async => await _displayTextModificationDialog(
                context,
                widget.student.setSize,
                widget.student.target,
                widget.student.name,
                widget.student.id),
          ),
          title: Text(widget.student.name),
          subtitle: Text(
              "Target: ${widget.student.target}, \nSet Size: ${widget.student.setSize}, \nID: ${widget.student.id}"),
        ),
      ),
    );
  }
}
