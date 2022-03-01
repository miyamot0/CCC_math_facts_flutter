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
import 'package:covcopcomp_math_fact/screens/home/edit_form.dart';
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
import '../visualfeedback.dart';

class StudentTile extends StatefulWidget {
  final Student student;

  const StudentTile({Key key, this.student}) : super(key: key);

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  // Gets the respective set of icons (randomize if necessary)
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

  // Parse the embedded json for math problems
  Future<MathFactData> _parseJson() async {
    return await parseJsonFromAssets('assets/mathfacts.json')
        .then((map) => MathFactData.fromJson(map));
  }

  // Build out templated string for entries
  Widget _buildStudentDescription(Student student) {
    // ignore: prefer_adjacent_string_concatenation
    return Text(
      // ignore: prefer_adjacent_string_concatenation
      "Current assignment: ${student.target}, \nCurrent set size: ${student.setSize} \n" +
          "Current set: ${student.set}, \nSet Randomization: ${student.randomized}, \nID: ${student.id} \n" +
          "Orientation Preference: ${student.orientationPreference}, \nOrientation Setting: ${student.preferredOrientation}, \nMetric: ${student.metric}",
      style: const TextStyle(fontSize: 18.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    bool isInPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Render bottom modal sheet
    void _editParticipantModal() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                  left: 60.0,
                  right: 60.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: EditForm(
                  setSize: widget.student.setSize,
                  set: widget.student.set,
                  name: widget.student.name,
                  id: widget.student.id,
                  randomized: widget.student.randomized,
                  targetSkill: widget.student.target,
                  orientationPreference: widget.student.orientationPreference,
                  preferredOrientation: widget.student.preferredOrientation,
                  metric: widget.student.metric),
            ));
          });
    }

    // Show student-specific feedback
    void _showVisualFeedback(context, student) async {
      await DatabaseService(uid: user.uid)
          .getStudentPerformanceCollection(student)
          .then((performances) async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VisualFeedback(
                    currentStudent: student,
                    currentPerformances: performances,
                  )),
        );
      });
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
              trailing: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.greenAccent),
                  child: IconButton(
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final jsonSet = await _parseJson();

                        bool showVertical =
                            widget.student.preferredOrientation ==
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
                                      operator: MathFactTypes()
                                          .getOperatorCharacter(
                                              widget.student.target),
                                    )),
                          ).then((result) {
                            isInPortrait = MediaQuery.of(context).orientation ==
                                Orientation.portrait;
                            SystemChrome.setPreferredOrientations([]);

                            if (result != null && result == true) {
                              _showVisualFeedback(context, widget.student);
                            }
                          });
                        } else {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MathFactsCCCHorizontal(
                                      student: widget.student,
                                      tid: user.uid,
                                      set: _getSet(widget.student, jsonSet),
                                      operator: MathFactTypes()
                                          .getOperatorCharacter(
                                              widget.student.target),
                                    )),
                          ).then((result) {
                            isInPortrait = MediaQuery.of(context).orientation ==
                                Orientation.portrait;
                            SystemChrome.setPreferredOrientations([]);

                            if (result != null && result == true) {
                              _showVisualFeedback(context, widget.student);
                            }
                          });
                        }
                      })),
              leading: GestureDetector(
                  child: const CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.blue,
                  ),
                  onTap: () async {},
                  onLongPress: () => _editParticipantModal()),
              title: Text(widget.student.name),
              subtitle: _buildStudentDescription(widget.student))),
    );
  }
}
