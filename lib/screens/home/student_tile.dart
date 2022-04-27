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
import 'package:covcopcomp_math_fact/screens/mathfacts/visualfeedback.dart';
import 'package:covcopcomp_math_fact/models/data.dart';
import 'package:covcopcomp_math_fact/models/usermodel.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:covcopcomp_math_fact/services/mind.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StudentTile extends StatefulWidget {
  final Student student;
  final UserData userData;

  const StudentTile({Key key, this.student, this.userData}) : super(key: key);

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    MediaQueryData mqData = MediaQuery.of(context);
    final user = Provider.of<UserModel>(context);

    final double horizontalBlock = mqData.size.width / 100;
    final double heroStudentRadiusSize = horizontalBlock * 7.5;
    final double tapButtonRadius = horizontalBlock * 9;
    final double tapButtonIconSize = horizontalBlock * 5;

    // Parse the embedded json for math problems
    Future<MathFactData> _parseJson() async {
      return await parseJsonFromAssets('assets/mathfacts.json').then((map) => MathFactData.fromJson(map));
    }

    // Render bottom modal sheet
    void _showEditParticipantModal() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(left: 60.0, right: 60.0, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: EditForm(
                studentData: widget.student,
              ),
            ));
          });
    }

    // Provide visual feedback to learner
    void _showVisualFeedbackScreen(UserModel user, Student student, BuildContext context) async {
      await DatabaseService(uid: user.uid).getStudentPerformanceCollection(student).then((performances) async {
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

    // Determine whether to provide visual feedback
    void _handleScreenReturn(dynamic result) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      if (result != null && result == true) {
        _showVisualFeedbackScreen(user, widget.student, context);
      }
    }

    // Determine how to present the task
    MaterialPageRoute _handleScreenOrientationRouting(MathFactData json) {
      return MaterialPageRoute(
          builder: (context) => MathFactsCCC(
                student: widget.student,
                tid: user.uid,
                set: getMathFactSet(widget.student, json),
                operator: MathFactTypes().getOperatorCharacter(widget.student.target),
              ));
    }

    // TODO: add in features for taking a picture here
    // TODO: launch intent following long press (if in settings mode)?
    // Construct leading widget
    Widget _individualStudentVisualWidget() {
      return Expanded(
          flex: 2,
          child: CircleAvatar(
            radius: heroStudentRadiusSize,
            backgroundColor: Colors.blue,
          ));
    }

    // Build out templated string for entries
    Widget _individualStudentRowTitle(String text) {
      // ignore: prefer_adjacent_string_concatenation
      return Text(
        "Name: $text",
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      );
    }

    // Build out templated string for entries
    Widget _individualStudentRowDescription(Student student) {
      // ignore: prefer_adjacent_string_concatenation
      return Text(
        // ignore: prefer_adjacent_string_concatenation
        "Skill Target: ${student.target}, \n" +
            //"Set size: ${student.setSize} \n" +
            "Stimulus set: ${student.set}, Randomizing set: ${student.randomized}, \n" +
            // ID:${student.id} \n
            // Orientation Preference: ${student.orientationPreference}, \n
            "Metric: ${student.metric}, " +
            "Aim Setting: ${student.aim}",
        style: const TextStyle(fontSize: 18.0),
      );
    }

    // Body showing the bulk of information
    Widget _studentInfoRowWidget() {
      return Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              _individualStudentRowTitle(widget.student.name),
              const SizedBox(
                height: 10,
              ),
              _individualStudentRowDescription(widget.student),
              const SizedBox(
                height: 10,
              ),
            ],
          ));
    }

    // Widget to access settings
    Widget _linkingButtonStudentVisual() {
      return Expanded(
          flex: 1,
          child: Container(
              constraints: BoxConstraints.expand(height: tapButtonRadius),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
              child: IconButton(
                  icon: Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: tapButtonIconSize,
                  ),
                  onPressed: () => _showVisualFeedbackScreen(user, widget.student, context))));
    }

    // Construct trailing widget
    Widget _linkingButtonStudentSettings() {
      return Expanded(
          flex: 1,
          child: Container(
              constraints: BoxConstraints.expand(height: tapButtonRadius),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
              child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: tapButtonIconSize,
                  ),
                  onPressed: () => _showEditParticipantModal())));
    }

    // Widget to commence exercise
    Widget _linkingButtonStudentTrial() {
      return Expanded(
          flex: 1,
          child: Container(
              constraints: BoxConstraints.expand(height: tapButtonRadius),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.greenAccent),
              child: IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: tapButtonIconSize,
                  ),
                  onPressed: () async {
                    final MathFactData jsonSet = await _parseJson();
                    final MaterialPageRoute route = _handleScreenOrientationRouting(jsonSet);

                    await Navigator.push(
                      context,
                      route,
                    ).then((result) => _handleScreenReturn(result));
                  })));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Card(
          margin: const EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              _individualStudentVisualWidget(),
              _studentInfoRowWidget(),
              widget.userData.revealSettings == true ? _linkingButtonStudentSettings() : const SizedBox.shrink(),
              _linkingButtonStudentVisual(),
              _linkingButtonStudentTrial()
            ]),
          )),
    );
  }
}
