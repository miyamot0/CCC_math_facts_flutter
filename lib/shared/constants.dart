// ignore_for_file: constant_identifier_names

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

import 'package:covcopcomp_math_fact/models/data.dart';
import 'package:covcopcomp_math_fact/models/student.dart';

import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink, width: 2.0)));

const cccTextStyle = TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold);

ButtonStyle keypadButtonStyle = TextButton.styleFrom(backgroundColor: Colors.green, primary: Colors.white);

enum CCCStatus { entry, begin, coverCopy, compare }

List<String> setSizeArray = ["8", "16", "24"];

// Gets the respective set of icons (randomize if necessary)
List<String> getMathFactSet(Student student, MathFactData data) {
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

class MathFactTypes {
  static const String Addition = "Math Facts-Addition";
  static const String Subtraction = "Math Facts-Subtraction";
  static const String Multiplication = "Math Facts-Multiplication";
  static const String Division = "Math Facts-Division";

  String getOperatorCharacter(String tag) {
    if (tag.contains('+')) {
      return '+';
    } else if (tag.contains('-')) {
      return '-';
    } else if (tag.contains('x')) {
      return 'x';
    } else if (tag.contains('/')) {
      return '/';
    } else {
      return '';
    }
  }

  static const List<String> FactsType = [
    MathFactTypes.Addition,
    MathFactTypes.Subtraction,
    MathFactTypes.Multiplication,
    MathFactTypes.Division
  ];
}

class Orientations {
  static const String Vertical = "Vertical";
  static const String Horizontal = "Horizontal";
  static const String NoPreference = "No Preference";
}

class Metrics {
  static const String Accuracy = "Accuracy";
  static const String Fluency = "Fluency";

  static const List<String> MetricPreference = [Metrics.Accuracy, Metrics.Fluency];
}

class MathFactSets {
  // ignore: non_constant_identifier_names
  static List<String> AvailableSets = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17'
  ];
}

class ErrorFeedback {
  static const String EachTrialAlways = "EachTrialAlways";
  static const String EachErredTrial = "EachErredTrial";
  static const String NoErrorFeedback = "NoErrorFeedback";

  static const List<String> FeedbackOptions = [
    ErrorFeedback.EachTrialAlways,
    ErrorFeedback.EachErredTrial,
    ErrorFeedback.NoErrorFeedback
  ];
}
