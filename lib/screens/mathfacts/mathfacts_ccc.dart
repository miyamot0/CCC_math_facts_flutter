import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/record_ccc_mfacts.dart';
import '../../models/student.dart';
import '../../models/usermodel.dart';
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
  bool isOngoing = false;
  bool initialLoad = true;

  List<String> localSet;

  String cachedString = '';

  String viewPanelString = '';
  String entryPanelString = '';
  String buttonText = '';
  Color entryPanel = Colors.grey;
  Color viewPanel = Colors.grey;
  Color viewPanelText = Colors.black;
  int errCount = 0;
  int nRetries = 0;
  int nCorrectInitial = 0;
  int numTrial = 1;

  DateTime start = DateTime.now();
  DateTime end;

  CCCStatus hud = CCCStatus.entry;

  static const String delCode = "Del";

  bool toVerify = false;
  bool initialTry = true;

  void _appendCharacter(String char) {
    if (hud != CCCStatus.coverCopy) {
      return;
    }

    setState(() {
      if (char == delCode) {
        if (entryPanelString.isEmpty) {
          return;
        }

        entryPanelString =
            entryPanelString.substring(0, entryPanelString.length - 1);
      } else {
        entryPanelString = entryPanelString + char;
      }
    });
  }

  void _toggleEntry(BuildContext context) {
    bool isMatching = null;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover, Copy, Compare'),
      ),
      body: Container(
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
                  hudStatus: hud),
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
          )),
    );
  }
}
