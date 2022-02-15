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
import 'package:covcopcomp_math_fact/screens/mathfacts/mathfacts_ccc.dart';
import 'package:covcopcomp_math_fact/shared/sheets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/data.dart';
import '../../models/usermodel.dart';
import '../../services/database.dart';
import '../../services/mind.dart';
import '../../shared/constants.dart';

class StudentTile extends StatefulWidget {
  final Student student;

  const StudentTile({Key key, this.student}) : super(key: key);

  @override
  State<StudentTile> createState() => _StudentTileState();
}

List<String> _getSet(Student student, MathFactData data) {
  List<String> mLocal = data.addition[int.parse(student.set)];
  mLocal.shuffle();

  return mLocal.take(int.parse(student.setSize)).toList();
}

Future<MathFactData> _parseJson() async {
  return await parseJsonFromAssets('assets/mathfacts.json')
      .then((map) => MathFactData.fromJson(map));
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
        String _set,
        String _id) async {
      _textFieldController.text = _name;

      final jsonSet = await _parseJson();
      List<int> sets = Iterable<int>.generate(jsonSet.additionSets).toList();
      List<String> strSets = sets.map((i) => i.toString()).toList();

      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Update Student Information'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                      items: factsType.map((setting) {
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
                      items: setSizeArray.map((setting) {
                        return DropdownMenuItem(
                            value: setting, child: Text(setting));
                      }).toList(),
                      onChanged: (String value) =>
                          _setSizeEdit = value.toString(),
                    ),
                    DropdownButtonFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Select set number"),
                      value: _set,
                      items: strSets.map((setting) {
                        return DropdownMenuItem(
                            value: setting, child: Text(setting));
                      }).toList(),
                      onChanged: (value) => _set = value,
                    ),
                  ],
                )),
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
                              _setSizeEdit, _exerciseEdit, _set, _id);

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
            onTap: () async {
              final jsonSet = await _parseJson();

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MathFactsCCC(
                          student: widget.student,
                          tid: user.uid,
                          set: _getSet(widget.student, jsonSet),
                        )),
              );
            },
            onLongPress: () async => await _displayTextModificationDialog(
                context,
                widget.student.setSize,
                widget.student.target,
                widget.student.name,
                widget.student.set,
                widget.student.id),
          ),
          title: Text(widget.student.name),
          subtitle: Text(
              "Current assignment: ${widget.student.target}, \nCurrent set size: ${widget.student.setSize} \nCurrent set: ${widget.student.set}, \nID: ${widget.student.id}"),
        ),
      ),
    );
  }
}
