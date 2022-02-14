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

  //String _entryBar;
  List<String> listProblems = ["9+8=17", "5+3=8", "6+9=15", "3+5=8", "3+3=6"];

  //List<String> dynamicProblemList;
  String viewPanelString = '';
  String entryPanelString = '';
  Color entryPanel = Colors.grey;
  Color viewPanel = Colors.grey;
  Color viewPanelText = Colors.black;

  CCCStatus hud = CCCStatus.entry;

  static const String delCode = "Del";

  void _appendCharacter(String char) {
    if (hud != CCCStatus.coverCopy) {
      return;
    }

    print(char);

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

  void _toggleEntry() {
    setState(() {
      if (hud == CCCStatus.entry) {
        hud = CCCStatus.begin;

        viewPanel = Colors.white;
        viewPanelText = Colors.black;
        entryPanel = Colors.grey;
      } else if (hud == CCCStatus.begin) {
        hud = CCCStatus.coverCopy;

        viewPanel = Colors.grey;
        viewPanelText = Colors.grey;
        entryPanel = Colors.white;
      } else if (hud == CCCStatus.coverCopy) {
        hud = CCCStatus.compare;

        viewPanel = Colors.white;
        viewPanelText = Colors.black;
        entryPanel = Colors.white;
      } else {
        // TODO: need verification logic here
        hud = CCCStatus.begin;
        viewPanelString = '';
        entryPanelString = '';
      }

      print('status: $hud');
    });
  }

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
                                        isOngoing = true;
                                        listProblems.removeAt(index);
                                      });

                                      _toggleEntry();

                                      /*
                                      Future.delayed(const Duration(seconds: 3))
                                          .then((value) {
                                        isOngoing = false;

                                        setState(() {
                                          dynamicProblemList = null;
                                          modString = null;
                                        });
                                      });
                                      */
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
