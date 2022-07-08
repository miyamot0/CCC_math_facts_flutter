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

import 'package:covcopcomp_math_fact/models/record_ccc_mfacts.dart';
import 'package:covcopcomp_math_fact/models/student.dart';
import 'package:covcopcomp_math_fact/models/factmodel.dart';
import 'package:covcopcomp_math_fact/screens/mathfacts/heads_up.dart';
import 'package:covcopcomp_math_fact/screens/mathfacts/key_pad.dart';
import 'package:covcopcomp_math_fact/screens/mathfacts/math_scoring.dart';
import 'package:covcopcomp_math_fact/services/database.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:covcopcomp_math_fact/shared/themes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:avatar_glow/avatar_glow.dart';

class MathFactsCCC extends StatefulWidget {
  const MathFactsCCC({Key key, this.student, this.tid, this.set, this.operator}) : super(key: key);

  final Student student;
  final String tid;
  final List<String> set;
  final String operator;

  @override
  _MathFactsCCCState createState() => _MathFactsCCCState();
}

class _MathFactsCCCState extends State<MathFactsCCC> {
  bool isOngoing = false, initialLoad = true, toVerify = false, initialTry = true;

  bool animateList = true;
  bool animateButton = false;
  bool illustrateKeys = false;

  List<String> localSet;
  List<FactModel> factModelList;

  String cachedString = '', viewPanelStringInternal = '', entryPanelStringInternal = '', buttonText = '';

  List<InlineSpan> viewPanelString = [];
  List<InlineSpan> entryPanelStringView = [];
  List<int> correctDigits = [], totalDigits = [];

  Color entryPanel = Colors.grey, viewPanel = Colors.grey, viewPanelText = Colors.black, listViewTextColor = Colors.black;

  int errCount = 0, nRetries = 0, nCorrectInitial = 0, numTrial = 1, nTotalDynamic;

  DateTime start = DateTime.now(), end;
  DateTime pretrial = DateTime.now();
  DateTime current;

  CCCStatus hud = CCCStatus.entry;

  static const String delCode = "Del";
  static const String strPad = ' ';
  static RegExp regExp = RegExp(
    r"(\d[^\+\-\x\\==]*)+",
    caseSensitive: false,
    multiLine: true,
  );

  // Handle branching logic for error message
  bool shouldShowFeedback(bool trialError) {
    if (widget.student.errorFeedback == ErrorFeedback.EachTrialAlways) {
      return true;
    } else if (trialError && widget.student.errorFeedback == ErrorFeedback.EachErredTrial) {
      return true;
    } else {
      return false;
    }
  }

  // Determine how much padding to provided for a given string
  int _nPad(String str) {
    const int base = 4;

    if (str == null || str.isEmpty) {
      return base - 0;
    } else {
      return base - str.length;
    }
  }

  // Display human-readable math problem for sample
  List<InlineSpan> _verticalizeString(String str) {
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
        String textToInclude2 = textToInclude.padLeft(_nPad(textToInclude), strPad);

        newText.add(TextSpan(text: textToInclude2));
        newText.add(const TextSpan(text: "\r\n"));
      } else if (iter == 1) {
        String textToInclude = operator + " " + reg.group(1).trim();
        String textToInclude2 = textToInclude.padLeft(_nPad(textToInclude), strPad);

        newText.add(TextSpan(text: textToInclude2, style: const TextStyle(decoration: TextDecoration.underline)));
        newText.add(const TextSpan(text: "\r\n"));
      } else {
        String textToInclude = reg.group(1).trim();
        String textToInclude2 = textToInclude.padLeft(_nPad(textToInclude), strPad);

        TextSpan newText3 = TextSpan(text: textToInclude2);

        newText.add(newText3);
        newText.add(const TextSpan(text: "\r"));
      }

      iter++;
    }

    return newText;
  }

  // Display human-readable math problem for editor
  List<InlineSpan> _verticalizeStringEditor(String str) {
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
        newText.add(TextSpan(text: reg.group(1).padLeft(_nPad(reg.group(1).trim()), strPad)));
      }
      newText.add(const TextSpan(text: "\r\n"));
      newText.add(TextSpan(text: operator));
    } else if (regExp.allMatches(str).length <= 1 && !str.contains(strPad)) {
      for (RegExpMatch reg in regExp.allMatches(str)) {
        if (iter == 0) {
          String textToInclude = reg.group(1).trim();

          newText.add(TextSpan(text: textToInclude.padLeft(_nPad(textToInclude), strPad)));
          newText.add(const TextSpan(text: "\r\n"));
        }

        iter++;
      }

      newText.add(TextSpan(text: operator.padLeft(_nPad(operator), strPad).trim()));
      newText.add(const TextSpan(text: "\r\n"));
    } else if (regExp.allMatches(str).length == 2 && !str.contains('=')) {
      for (RegExpMatch reg in regExp.allMatches(str)) {
        if (iter == 0) {
          String textToInclude = reg.group(1).trim();
          newText.add(TextSpan(text: textToInclude.padLeft(_nPad(textToInclude), strPad)));
          newText.add(const TextSpan(text: "\r\n"));
        } else if (iter == 1) {
          String textToInclude = reg.group(1);
          newText.add(TextSpan(
            text: (operator + " " + textToInclude).padLeft(_nPad((operator + " " + textToInclude)), strPad),
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
          newText.add(TextSpan(text: textToInclude.padLeft(_nPad(textToInclude), strPad)));
          newText.add(const TextSpan(text: "\r\n"));
        } else if (iter == 1) {
          String textToInclude = reg.group(1).trim();
          newText.add(TextSpan(
              text: (operator + " " + textToInclude).padLeft(_nPad(textToInclude), strPad),
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
          newText.add(TextSpan(text: textToInclude.padLeft(_nPad(textToInclude), strPad)));
          newText.add(const TextSpan(text: "\r\n"));
        } else if (iter == 1) {
          String textToInclude = reg.group(1);
          newText.add(TextSpan(
              text: (operator + " " + textToInclude).padLeft(_nPad((operator + " " + textToInclude)), strPad),
              style: const TextStyle(decoration: TextDecoration.underline)));
          newText.add(const TextSpan(text: "\r\n"));
        } else {
          TextSpan newText3 = TextSpan(text: reg.group(1).padLeft(_nPad(reg.group(1)), strPad));

          newText.add(newText3);
          newText.add(const TextSpan(text: "\r"));
        }

        iter++;
      }
    }

    return newText;
  }

  // Callback to add input from keyboard to editor
  void _appendCharacterToEditor(String char) {
    if (hud != CCCStatus.coverCopy) {
      return;
    }

    // Rule: no multiple operators
    if (char == widget.operator && entryPanelStringInternal.contains(widget.operator)) {
      return;
    }

    // Rule: no multiple equals
    if (char == '=' && entryPanelStringInternal.contains('=')) {
      return;
    }

    // Rule: no '=' before an operator
    if (char == '=' && !entryPanelStringInternal.contains(widget.operator)) {
      return;
    }

    // Rule: no '=', before an digit AFTER operator
    if (char == '=' && entryPanelStringInternal.contains(widget.operator)) {
      List<String> problemParts = entryPanelStringInternal.split(widget.operator);

      // If just 1 part, disregard (no digits after operator yet)
      if (problemParts.length <= 1) {
        return;
      }

      // If just whitespace, disregard
      if (problemParts[1].trim().length == 0) {
        return;
      }
    }


    if (char == delCode) {
      if (entryPanelStringInternal.isEmpty == true) {
        return;
      }

      entryPanelStringInternal = entryPanelStringInternal.substring(0, entryPanelStringInternal.length - 1);
    } else {
      entryPanelStringInternal = entryPanelStringInternal + char;
    }

    setState(() {

      if (animateButton == false) {
        animateButton = true;
      }

      entryPanelStringView = _verticalizeStringEditor(entryPanelStringInternal);
    });
  }

  // Callback for button triggering next phase of intervention
  void _buttonPressEvent(BuildContext context) {
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

        animateList = false;
        animateButton = true;

        listViewTextColor = Colors.grey[200];
      } else if (hud == CCCStatus.begin) {
        hud = CCCStatus.coverCopy;

        viewPanel = Colors.grey;
        viewPanelText = Colors.grey;
        entryPanel = Colors.white;
        buttonText = 'Copied';
        toVerify = false;
        illustrateKeys = true;
        animateButton = false;

      } else if (hud == CCCStatus.coverCopy) {
        hud = CCCStatus.compare;

        viewPanel = Colors.white;
        viewPanelText = Colors.black;
        entryPanel = Colors.white;
        buttonText = 'Compare';
        toVerify = false;
        illustrateKeys = false;

      } else {
        hud = CCCStatus.entry;

        isMatching = viewPanelStringInternal.trim() == entryPanelStringInternal.trim();

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

        // TODO do counts here

        String currentStringDisplayed = viewPanelStringInternal;
        int totalDigitsShown = calculateDigitsTotal(currentStringDisplayed);
        String currentStringEntered = entryPanelStringInternal;
        int totalDigitsCorrect =
              calculateDigitsCorrect(currentStringEntered, currentStringDisplayed, widget.operator);
        
        DateTime current = DateTime.now();

        int secs = current.difference(pretrial).inSeconds;

        factModelList.add(FactModel(
          factType: widget.student.target,
          factString: currentStringDisplayed,
          factEntry: currentStringEntered,
          factCorrect: isMatching,
          initialTry: initialTry,
          latencySeconds: secs));

        pretrial = DateTime.now();

        if (shouldShowFeedback(!isMatching)) {
          _showMessageDialog(context);
        } else {

          totalDigits.add(totalDigitsShown);
          correctDigits.add(totalDigitsCorrect);

          setState(() {
            viewPanelString = [];

            entryPanelStringInternal = '';
            entryPanelStringView = [];
            buttonText = '';
            isOngoing = false;

            animateList = true;
            animateButton = false;
            illustrateKeys = false;

            entryPanel = Colors.grey;
            viewPanel = Colors.grey;
            listViewTextColor = Colors.black;
          });

          numTrial++;
          initialTry = true;

          if (localSet.isEmpty) {
            _submitDataToFirebase();
          }
        }
      }
    });
  }

  // Push local data to server
  void _submitDataToFirebase() async {
    end = DateTime.now();

    int secs = end.difference(start).inSeconds;

    RecordMathFacts studentRecord = RecordMathFacts(
            tid: widget.tid,
            id: widget.student.id,
            setSize: nTotalDynamic.toString(),
            target: widget.student.target,
            dateTimeStart: start.toString(),
            dateTimeEnd: end.toString(),
            errCount: errCount,
            nRetries: nRetries,
            nCorrectInitial: nCorrectInitial,
            delaySec: 0,
            set: int.parse(widget.student.set),
            sessionDuration: secs,
            totalDigits: totalDigits.sum,
            correctDigits: correctDigits.sum);

    await DatabaseService(uid: widget.tid)
        .addToStudentPerformanceCollection(studentRecord)
        .then((documentReference) async {
          await DatabaseService(uid: widget.tid).addItemResponses(studentRecord, documentReference.id, factModelList);
        })
        .then((value) => Navigator.pop(context, true));
  }

  // Show message log
  void _showMessageDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Compare Facts"),
          content: const Text("Please check your facts. Do you need to try again?"),
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
                String currentStringDisplayed = viewPanelStringInternal;
                int totalDigitsShown = calculateDigitsTotal(currentStringDisplayed);
                totalDigits.add(totalDigitsShown);

                String currentStringEntered = entryPanelStringInternal;
                int totalDigitsCorrect =
                    calculateDigitsCorrect(currentStringEntered, currentStringDisplayed, widget.operator);
                correctDigits.add(totalDigitsCorrect);

                setState(() {
                  viewPanelString = [];

                  entryPanelStringInternal = '';
                  entryPanelStringView = [];
                  buttonText = '';
                  isOngoing = false;

                  entryPanel = Colors.grey;
                  viewPanel = Colors.grey;
                  listViewTextColor = Colors.black;
                });

                numTrial++;
                initialTry = true;

                if (localSet.isEmpty) {
                  _submitDataToFirebase();
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (initialLoad) {
      initialLoad = false;
      localSet = widget.set;
      factModelList = [];
      nTotalDynamic = localSet.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover, Copy, Compare'),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () => _submitDataToFirebase(),
              child: Text("Upload"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("${widget.student.name} (Set Size: ${widget.student.setSize})",
                      style: AppThemes.PrimaryTextStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 36.0, color: Colors.black)),
                  const SizedBox(
                    height: 20,
                  ),
                  HeadsUpPanel(
                    viewPanelString: viewPanelString,
                    entryPanelColor: entryPanel,
                    entryPanelString: entryPanelStringView,
                    buttonText: buttonText,
                    viewPanelColor: viewPanel,
                    viewPanelText: viewPanelText,
                    toggleEntry: _buttonPressEvent,
                    hudStatus: hud,
                    animatedButton: animateButton
                  ),
                  const SizedBox(
                    height: 20,
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
                                            viewPanelStringInternal = localSet[index];

                                            viewPanelString = _verticalizeString(viewPanelStringInternal);

                                            cachedString = viewPanelStringInternal;
                                            isOngoing = true;
                                            buttonText = 'Cover';
                                            localSet.removeAt(index);
                                          });

                                          _buttonPressEvent(context);
                                        },
                                        child: AvatarGlow(
                                          endRadius: 30,
                                          animate: animateList,
                                          glowColor: Colors.blue,
                                          child: Material(
                                            elevation: 10.0,
                                            color: Colors.greenAccent,
                                            shape: const CircleBorder(),
                                            child: const CircleAvatar(
                                              
                                              foregroundColor: Colors.blue,
                                              radius: 15
                                            ),
                                          ),
                                        )),
                                    title: Text(
                                      localSet[index],
                                      style: AppThemes.PrimaryProblemSizing.copyWith(color: listViewTextColor),
                                    ),
                                  );
                                }),
                          ),
                          Expanded(
                            flex: 2,
                            child: KeyPad(
                              appendInput: _appendCharacterToEditor, 
                              readyForEntry: illustrateKeys,
                              operatorChar: widget.operator),
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
