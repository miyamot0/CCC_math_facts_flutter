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

  String _entryBar;
  List<String> listProblems = ["9+8=17", "5+3=8", "6+9=15", "3+5=8", "3+3=6"];

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
                entryBarString: _entryBar,
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

                                      print('Tap, Index: $index');

                                      setState(() {
                                        _entryBar = listProblems[index];
                                        isOngoing = true;
                                        listProblems.removeAt(index);
                                      });

                                      Future.delayed(Duration(seconds: 3))
                                          .then((value) {
                                        print('Re-enabled');
                                        isOngoing = false;

                                        setState(() {
                                          _entryBar = "";
                                        });
                                      });
                                    },
                                    child: CircleAvatar(
                                      foregroundColor: Colors.blue,
                                    )),
                                title: Text(
                                  listProblems[index],
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              );
                            }),
                      ),
                      const Expanded(
                        flex: 1,
                        child: KeyPad(),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
