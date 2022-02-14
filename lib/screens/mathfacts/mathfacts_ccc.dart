import 'dart:async';

import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import 'heads_up.dart';
import 'key_pad.dart';

class MathFactsCCC extends StatefulWidget {
  const MathFactsCCC({Key key}) : super(key: key);

  @override
  _MathFactsCCCState createState() => _MathFactsCCCState();
}

class _MathFactsCCCState extends State<MathFactsCCC> {
  bool isOngoing = false;

  List<String> listProblems = ["9+8=17", "5+3=8", "6+9=15", "3+5=8", "3+3=6"];
  String cachedString = '';

  String viewPanelString = '';
  String entryPanelString = '';
  String buttonText = '';
  Color entryPanel = Colors.grey;
  Color viewPanel = Colors.grey;
  Color viewPanelText = Colors.black;

  CCCStatus hud = CCCStatus.entry;

  static const String delCode = "Del";

  bool toVerify = false;

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
        hud = CCCStatus.begin;

        isMatching = viewPanelString.trim() == entryPanelString.trim();

        toVerify = true;
      }

      if (toVerify) {
        toVerify = false;

        _showMessageDialog(context);

        //TODO record here
      }
    });
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
                });

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

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
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
                            itemCount: listProblems.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: GestureDetector(
                                    onTap: () {
                                      if (isOngoing) {
                                        return;
                                      }

                                      print('tapped');

                                      setState(() {
                                        viewPanelString = listProblems[index];
                                        cachedString = viewPanelString;
                                        isOngoing = true;
                                        buttonText = 'Cover';
                                        listProblems.removeAt(index);
                                      });

                                      _toggleEntry(context);
                                    },
                                    child: const CircleAvatar(
                                      foregroundColor: Colors.blue,
                                    )),
                                title: Text(
                                  listProblems[index],
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
