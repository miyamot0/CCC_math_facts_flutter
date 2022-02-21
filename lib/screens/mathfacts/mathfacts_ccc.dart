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

import 'package:flutter/material.dart';

import '../../models/record_ccc_mfacts.dart';
import '../../models/student.dart';
import '../../services/database.dart';
import '../../shared/constants.dart';

import 'heads_up.dart';
import 'key_pad.dart';

class MathFactsCCC extends StatefulWidget {
  const MathFactsCCC({Key key, this.student, this.tid, this.set})
      : super(key: key);

  final Student student;
  final String tid;
  final List<String> set;

  @override
  _MathFactsCCCState createState() => _MathFactsCCCState();
}

class _MathFactsCCCState extends State<MathFactsCCC> {
  bool isOngoing = false,
      initialLoad = true,
      toVerify = false,
      initialTry = true,
      isVertical = false;

  List<String> localSet;

  String cachedString = '',
      viewPanelString = '',
      entryPanelString = '',
      buttonText = '';

  Color entryPanel = Colors.grey,
      viewPanel = Colors.grey,
      viewPanelText = Colors.black;

  int errCount = 0, nRetries = 0, nCorrectInitial = 0, numTrial = 1;

  DateTime start = DateTime.now(), end;

  CCCStatus hud = CCCStatus.entry;

  static const String delCode = "Del";

  _appendCharacter(String char) {
    if (hud != CCCStatus.coverCopy) {
      return;
    }

    setState(() {
      if (char == delCode) {
        if (entryPanelString.isEmpty) {
          return;
        }

        // TODO remove new line
        entryPanelString =
            entryPanelString.substring(0, entryPanelString.length - 1);
      } else {
        // TODO add new line
        entryPanelString = entryPanelString + char;
      }
    });
  }

  _toggleEntry(BuildContext context) {
    bool isMatching;

    setState(() {
      if (buttonText.isEmpty) return;

      if (hud == CCCStatus.entry) {
        hud = CCCStatus.begin;

        viewPanel = Colors.white;
        viewPanelText = Colors.black;
        entryPanel = Colors.grey;
        buttonText = 'Cover';
        toVerify = false;
      } else if (hud == CCCStatus.begin) {
        hud = CCCStatus.coverCopy;

        viewPanel = Colors.grey;
        viewPanelText = Colors.grey;
        entryPanel = Colors.white;
        buttonText = 'Copied';
        toVerify = false;
      } else if (hud == CCCStatus.coverCopy) {
        hud = CCCStatus.compare;

        viewPanel = Colors.white;
        viewPanelText = Colors.black;
        entryPanel = Colors.white;
        buttonText = 'Compare';
        toVerify = false;
      } else {
        hud = CCCStatus.entry;

        isMatching = viewPanelString.trim() == entryPanelString.trim();

        toVerify = true;
      }

      if (toVerify) {
        toVerify = false;

        if (initialTry && isMatching) {
          nCorrectInitial++;
        }

        if (!isMatching) {
          errCount++;
        }

        _showMessageDialog(context);
      }
    });
  }

  _submitData() async {
    end = DateTime.now();

    int secs = end.difference(start).inSeconds;

    await DatabaseService(uid: widget.tid)
        .addToStudentPerformanceCollection(RecordMathFacts(
            tid: widget.tid,
            id: widget.student.id,
            setSize: widget.student.setSize,
            target: widget.student.target,
            dateTimeStart: start.toString(),
            dateTimeEnd: end.toString(),
            errCount: errCount,
            nRetries: nRetries,
            nCorrectInitial: nCorrectInitial,
            delaySec: 0,
            set: int.parse(widget.student.set),
            sessionDuration: secs))
        .then((value) => Navigator.of(context).pop());
  }

  _showMessageDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Compare Facts"),
          content:
              const Text("Please check your facts. Do you need to try again?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                setState(() {
                  viewPanelString = cachedString;
                  viewPanel = Colors.white;
                  viewPanelText = Colors.black;
                  entryPanel = Colors.grey;
                  buttonText = 'Cover';
                  toVerify = false;

                  entryPanelString = '';
                  isOngoing = true;

                  hud = CCCStatus.begin;
                });

                nRetries++;
                initialTry = false;

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                setState(() {
                  viewPanelString = '';

                  entryPanelString = '';
                  buttonText = '';
                  isOngoing = false;
                });

                numTrial++;
                initialTry = true;

                if (localSet.isEmpty) {
                  _submitData();
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (initialLoad) {
      initialLoad = false;

      localSet = widget.set;
    }

    isVertical = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover, Copy, Compare'),
        actions: [
          Center(
            child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  "Name: ${widget.student.name}, Set Size: ${widget.student.setSize}",
                  style: cccTextStyle.copyWith(fontSize: 24.0),
                )),
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isVertical = orientation == Orientation.portrait;

          return Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  HeadsUpPanel(
                    viewPanelString: viewPanelString,
                    entryPanelColor: entryPanel,
                    entryPanelString: entryPanelString,
                    buttonText: buttonText,
                    viewPanelColor: viewPanel,
                    viewPanelText: viewPanelText,
                    toggleEntry: _toggleEntry,
                    hudStatus: hud,
                    isVertical: isVertical,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                                itemCount: localSet.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: GestureDetector(
                                        onTap: () {
                                          if (isOngoing) {
                                            return;
                                          }

                                          setState(() {
                                            viewPanelString = localSet[index];
                                            cachedString = viewPanelString;
                                            isOngoing = true;
                                            buttonText = 'Cover';
                                            localSet.removeAt(index);
                                          });

                                          _toggleEntry(context);
                                        },
                                        child: const CircleAvatar(
                                          foregroundColor: Colors.blue,
                                        )),
                                    title: Text(
                                      localSet[index],
                                      style: const TextStyle(fontSize: 42.0),
                                    ),
                                  );
                                }),
                          ),
                          Expanded(
                            flex: 2,
                            child: KeyPad(appendInput: _appendCharacter),
                          ),
                        ],
                      ))
                ],
              ));
        },
      ),
    );
  }
}
