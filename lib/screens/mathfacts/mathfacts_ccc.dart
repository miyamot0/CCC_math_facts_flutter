import 'dart:async';

import 'package:flutter/material.dart';

import 'heads_up.dart';
import 'key_pad.dart';

class MathFactsCCC extends StatefulWidget {
  const MathFactsCCC({Key key}) : super(key: key);

  @override
  _MathFactsCCCState createState() => _MathFactsCCCState();
}

class _MathFactsCCCState extends State<MathFactsCCC> {
  /*

  Column _createView(List<Object> probList) {
    int rows = probList.length;

    List<Widget> dynContainer = [];
    List<Widget> dynRows = [];

    probList.forEach((element) {
      List<Object> mod = element as List<Object>;
      print(mod);

      int len = mod.length;

      List<Widget> dynRow = [];

      for (int c = 0; c < len; c++) {
        String value = mod[c] ?? "";

        Container dynC = Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          decoration: BoxDecoration(color: Colors.white, border: Border.all()),
          height: 50,
          child: Text(value),
        );

        Expanded dyn = Expanded(
          child: dynC,
        );

        dynRow.add(dyn);
      }

      dynRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: dynRow,
      ));
    });

    //dynContainer.add(newRow);
    //print(dynRow);

    //Row newRow = Row(
    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //  children: dynRow,
    //);

    return Column(
      children: dynRows,
    );
  }

  */

  bool isOngoing = false;

  //String _entryBar;
  List<String> listProblems = ["9+8=17", "5+3=8", "6+9=15", "3+5=8", "3+3=6"];

  List<String> dynamicProblemList;
  Color entryPanel = Colors.grey;
  Color viewPanel = Colors.white;
  bool showEntry = false;

  void _toggleEntry() {
    setState(() {
      showEntry = !showEntry;
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
                entryBarDynamic: dynamicProblemList,
                entryPanelColor: entryPanel,
                viewPanelColor: viewPanel,
                toggleEntry: _toggleEntry,
                showEntry: showEntry,
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
                            itemCount: listProblems.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: GestureDetector(
                                    onTap: () {
                                      if (isOngoing) {
                                        return;
                                      }

                                      List<String> characters =
                                          listProblems[index].trim().split("");

                                      List<String> modString = [];

                                      characters.forEach((c) {
                                        switch (c) {
                                          case '0':
                                            modString.add('zero.svg');
                                            break;
                                          case '1':
                                            modString.add('one.svg');
                                            break;
                                          case '2':
                                            modString.add('two.svg');
                                            break;
                                          case '3':
                                            modString.add('three.svg');
                                            break;
                                          case '4':
                                            modString.add('four.svg');
                                            break;
                                          case '5':
                                            modString.add('five.svg');
                                            break;
                                          case '6':
                                            modString.add('six.svg');
                                            break;
                                          case '7':
                                            modString.add('seven.svg');
                                            break;
                                          case '8':
                                            modString.add('eight.svg');
                                            break;
                                          case '9':
                                            modString.add('nine.svg');
                                            break;
                                          case '+':
                                            modString.add('add.svg');
                                            break;
                                          case '-':
                                            modString.add('subtract.svg');
                                            break;
                                          case 'x':
                                            modString.add('multiply.svg');
                                            break;
                                          case '/':
                                            modString.add('divide.svg');
                                            break;
                                          case '=':
                                            modString.add('equals.svg');
                                            break;
                                        }
                                      });

                                      setState(() {
                                        dynamicProblemList = modString;
                                        isOngoing = true;
                                        listProblems.removeAt(index);
                                      });

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
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                              );
                            }),
                      ),
                      const Expanded(
                        flex: 2,
                        child: KeyPad(),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
