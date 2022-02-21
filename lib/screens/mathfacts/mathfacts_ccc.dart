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
import 'package:flutter/services.dart';

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
      viewPanelStringInternal = '',
      entryPanelStringInternal = '',
      buttonText = '';

  List<InlineSpan> viewPanelString = [];
  List<InlineSpan> entryPanelStringView = [];

  Color entryPanel = Colors.grey,
      viewPanel = Colors.grey,
      viewPanelText = Colors.black;

  int errCount = 0, nRetries = 0, nCorrectInitial = 0, numTrial = 1;

  DateTime start = DateTime.now(), end;

  CCCStatus hud = CCCStatus.entry;

  static const String delCode = "Del";

  List<InlineSpan> _verticalizeString(String str) {
    RegExp regExp = RegExp(
      r"(\d[^\+\-\x\\==]*)+",
      caseSensitive: false,
      multiLine: true,
    );

    String operator = "";
    int iter = 0;

    List<InlineSpan> newText = [];

    if (str.contains('+')) {
      operator = '+';
    } else if (str.contains('-')) {
      operator = '-';
    } else if (str.contains('x')) {
      operator = 'x';
    } else if (str.contains('/')) {
      operator = '/';
    }

    for (RegExpMatch reg in regExp.allMatches(str)) {
      if (iter == 0) {
        String textToInclude = reg.group(1).trim();
        newText.add(TextSpan(text: textToInclude.padLeft(4)));
        newText.add(const TextSpan(text: "\r\n"));
      } else if (iter == 1) {
        String textToInclude = reg.group(1);
        newText.add(TextSpan(
            text: (operator + " " + textToInclude).padLeft(4).trim(),
            style: const TextStyle(decoration: TextDecoration.underline)));
        newText.add(const TextSpan(text: "\r\n"));
      } else {
        TextSpan newText3 = TextSpan(text: reg.group(1).padLeft(4, ' ').trim());

        newText.add(newText3);
      }

      iter++;
    }

    return newText;
  }

  List<InlineSpan> _verticalizeStringEditor(String str) {
    RegExp regExp = RegExp(
      r"(\d[^\+\-\x\\==]*)+",
      caseSensitive: false,
      multiLine: true,
    );

    String operator = "";
    int iter = 0;

    List<InlineSpan> newText = [];

    if (str.contains('+')) {
      operator = '+';
    } else if (str.contains('-')) {
      operator = '-';
    } else if (str.contains('x')) {
      operator = 'x';
    } else if (str.contains('/')) {
      operator = '/';
    } else {
      operator = ' ';
    }

    if (regExp.allMatches(str).length < 2 && operator == ' ') {
      for (RegExpMatch reg in regExp.allMatches(str)) {
        newText.add(TextSpan(text: reg.group(1).padLeft(4, ' ')));
      }
      newText.add(const TextSpan(text: "\r\n"));
      newText.add(TextSpan(text: operator));
    } else if (regExp.allMatches(str).length <= 1 && !str.contains(' ')) {
      for (RegExpMatch reg in regExp.allMatches(str)) {
        if (iter == 0) {
          String textToInclude = reg.group(1).trim();

          newText.add(TextSpan(text: textToInclude.padLeft(4, ' ')));
          newText.add(const TextSpan(text: "\r\n"));
        }

        iter++;
      }

      newText.add(TextSpan(text: (operator).padLeft(4).trim()));
      newText.add(const TextSpan(text: "\r\n"));
    } else if (regExp.allMatches(str).length == 2 && !str.contains('=')) {
      for (RegExpMatch reg in regExp.allMatches(str)) {
        if (iter == 0) {
          String textToInclude = reg.group(1).trim();
          newText.add(TextSpan(text: textToInclude.padLeft(4, ' ')));
          newText.add(const TextSpan(text: "\r\n"));
        } else if (iter == 1) {
          String textToInclude = reg.group(1);
          newText.add(TextSpan(
            text: (operator + " " + textToInclude).padLeft(4, ' '),
          ));
          newText.add(const TextSpan(text: "\r\n"));
        }

        iter++;
      }

      newText.add(const TextSpan(text: "\r\n"));
    } else if (regExp.allMatches(str).length == 2 && str.contains('=')) {
      for (RegExpMatch reg in regExp.allMatches(str)) {
        if (iter == 0) {
          String textToInclude = reg.group(1).trim();
          newText.add(TextSpan(text: textToInclude.padLeft(4, ' ')));
          newText.add(const TextSpan(text: "\r\n"));
        } else if (iter == 1) {
          String textToInclude = reg.group(1);
          newText.add(TextSpan(
              text: (operator + " " + textToInclude).padLeft(4, ' '),
              style: const TextStyle(decoration: TextDecoration.underline)));
          newText.add(const TextSpan(text: "\r\n"));
        }

        iter++;
      }

      newText.add(const TextSpan(text: "\r\n"));
    } else if (regExp.allMatches(str).length == 3) {
      for (RegExpMatch reg in regExp.allMatches(str)) {
        if (iter == 0) {
          String textToInclude = reg.group(1).trim();
          newText.add(TextSpan(text: textToInclude.padLeft(4, ' ')));
          newText.add(const TextSpan(text: "\r\n"));
        } else if (iter == 1) {
          String textToInclude = reg.group(1);
          newText.add(TextSpan(
              text: (operator + " " + textToInclude).padLeft(4, ' '),
              style: const TextStyle(decoration: TextDecoration.underline)));
          newText.add(const TextSpan(text: "\r\n"));
        } else {
          TextSpan newText3 = TextSpan(text: reg.group(1).padLeft(4, ' '));

          newText.add(newText3);
        }

        iter++;
      }
    }

    return newText;
  }

  _appendCharacter(String char) {
    if (hud != CCCStatus.coverCopy) {
      return;
    }

    if (isVertical) {
      if (char == delCode) {
        if (entryPanelStringInternal.isEmpty == true) {
          return;
        }

        entryPanelStringInternal = entryPanelStringInternal.substring(
            0, entryPanelStringInternal.length - 1);
      } else {
        entryPanelStringInternal = entryPanelStringInternal + char;
      }

      setState(() {
        entryPanelStringView =
            _verticalizeStringEditor(entryPanelStringInternal);
      });
    } else {
      entryPanelStringInternal = entryPanelStringInternal + char;

      if (char == delCode) {
        if (entryPanelStringInternal.isEmpty == true) {
          return;
        }

        entryPanelStringInternal = entryPanelStringInternal.substring(
            0, entryPanelStringInternal.length - 1);
      } else {
        entryPanelStringInternal = entryPanelStringInternal + char;
      }
    }
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

        isMatching =
            viewPanelStringInternal.trim() == entryPanelStringInternal.trim();

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
                  entryPanelStringInternal = cachedString;
                  viewPanel = Colors.white;
                  viewPanelText = Colors.black;
                  entryPanel = Colors.grey;
                  buttonText = 'Cover';
                  toVerify = false;

                  entryPanelStringInternal = '';
                  entryPanelStringView = [];
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
                  viewPanelString = [];

                  entryPanelStringInternal = '';
                  entryPanelStringView = [];
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (initialLoad) {
      initialLoad = false;

      localSet = widget.set;
    }

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
                    entryPanelString: entryPanelStringView,
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
                                            viewPanelStringInternal =
                                                localSet[index];

                                            viewPanelString = isVertical == true
                                                ? _verticalizeString(
                                                    viewPanelStringInternal)
                                                : viewPanelStringInternal;

                                            cachedString =
                                                viewPanelStringInternal;
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
