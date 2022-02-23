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
import 'package:covcopcomp_math_fact/screens/mathfacts/mathfacts_ccc_h.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _StudentTileState extends State<StudentTile> {
  List<String> _getSet(Student student, MathFactData data) {
    List<String> mLocal;

    if (student.target == "Math Facts-Addition") {
      mLocal = data.addition[int.parse(student.set)];
    } else if (student.target == "Math Facts-Subtraction") {
      mLocal = data.subtraction[int.parse(student.set)];
    } else if (student.target == "Math Facts-Multiplication") {
      mLocal = data.multiplication[int.parse(student.set)];
    } else if (student.target == "Math Facts-Division") {
      mLocal = data.division[int.parse(student.set)];
    }

    if (student.randomized == true) {
      mLocal.shuffle();
    }

    return mLocal.take(int.parse(student.setSize)).toList();
  }

  Future<MathFactData> _parseJson() async {
    return await parseJsonFromAssets('assets/mathfacts.json')
        .then((map) => MathFactData.fromJson(map));
  }

  Widget _buildStudentDescription(Student student) {
    // ignore: prefer_adjacent_string_concatenation
    return Text(
      "Current assignment: ${student.target}, \nCurrent set size: ${student.setSize} \n" +
          "Current set: ${student.set}, \nSet Randomization: ${student.randomized}, \nID: ${student.id} \n" +
          "Orientation Preference: ${student.orientationPreference}, \nOrientation Setting: ${student.preferredOrientation}",
      style: const TextStyle(fontSize: 18.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    TextEditingController _textFieldController = TextEditingController();

    bool isInPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    Future<void> _displayTextModificationDialog(
        BuildContext context,
        String _setSizeEdit,
        String _exerciseEdit,
        String _name,
        String _set,
        String _id,
        bool _randomized,
        bool _preferredOrientation,
        String _orientationSetting) async {
      _textFieldController.text = _name;

      List<int> sets = Iterable<int>.generate(numberSetsMind).toList();
      List<String> strSets = sets.map((i) => i.toString()).toList();

      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Update Student Info'),
              content: Form(
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _textFieldController,
                      decoration: textInputDecoration.copyWith(
                          hintText: "Student Name", labelText: "Student Name:"),
                    ),
                    DropdownButtonFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Select exercise",
                          labelText: "Target Skill:"),
                      value: _exerciseEdit,
                      items: factsType.map((setting) {
                        return DropdownMenuItem(
                            value: setting, child: Text(setting));
                      }).toList(),
                      onChanged: (String value) =>
                          _exerciseEdit = value.toString(),
                    ),
                    DropdownButtonFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Set Size", labelText: "Size of Set:"),
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
                          hintText: "Select set number",
                          labelText: "Which Set:"),
                      value: _set,
                      items: strSets.map((setting) {
                        return DropdownMenuItem(
                            value: setting, child: Text(setting));
                      }).toList(),
                      onChanged: (value) => _set = value,
                    ),
                    DropdownButtonFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Problem Selection",
                          labelText: "Problem Selection:"),
                      value: _randomized == true ? 'Randomized' : 'Fixed',
                      items: ['Fixed', 'Randomized'].map((setting) {
                        return DropdownMenuItem(
                            value: setting, child: Text(setting));
                      }).toList(),
                      onChanged: (value) => _randomized =
                          value.toString() == "Randomized" ? true : false,
                    ),
                    DropdownButtonFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "Item Presentation",
                            labelText: "Item Presentation:"),
                        value: _orientationSetting,
                        items: orientationPreference.map((setting) {
                          return DropdownMenuItem(
                              value: setting, child: Text(setting));
                        }).toList(),
                        onChanged: (value) {
                          _preferredOrientation =
                              (value.toString() == orientationPreference[0])
                                  ? false
                                  : true;

                          _orientationSetting = value.toString();
                        }),
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
                          .updateStudentInCollection(Student(
                              id: _id,
                              set: _set,
                              setSize: _setSizeEdit,
                              target: _exerciseEdit,
                              randomized: _randomized,
                              name: _textFieldController.text,
                              preferredOrientation: _orientationSetting,
                              orientationPreference: _preferredOrientation));

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
                child: const CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.blue,
                ),
                onTap: () async {
                  final jsonSet = await _parseJson();

                  bool showVertical = widget.student.preferredOrientation ==
                          Orientations().Vertical ||
                      (widget.student.preferredOrientation ==
                              Orientations().NoPreference &&
                          isInPortrait);

                  if (showVertical == true) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MathFactsCCC(
                                student: widget.student,
                                tid: user.uid,
                                set: _getSet(widget.student, jsonSet),
                              )),
                    ).then((_) {
                      isInPortrait = MediaQuery.of(context).orientation ==
                          Orientation.portrait;
                      SystemChrome.setPreferredOrientations([]);
                    });
                  } else {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MathFactsCCCHorizontal(
                                student: widget.student,
                                tid: user.uid,
                                set: _getSet(widget.student, jsonSet),
                              )),
                    ).then((_) {
                      isInPortrait = MediaQuery.of(context).orientation ==
                          Orientation.portrait;
                      SystemChrome.setPreferredOrientations([]);
                    });
                  }
                },
                onLongPress: () async => await _displayTextModificationDialog(
                    context,
                    widget.student.setSize,
                    widget.student.target,
                    widget.student.name,
                    widget.student.set,
                    widget.student.id,
                    widget.student.randomized,
                    widget.student.orientationPreference,
                    widget.student.preferredOrientation),
              ),
              title: Text(widget.student.name),
              subtitle: _buildStudentDescription(widget.student))),
    );
  }
}
