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

enum CCCStatus { entry, begin, coverCopy, compare }

List<String> setSizeArray = ["8", "16", "24", "30", "50"];

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

  // Get operator for math activity
  String getOperatorCharacter(String tag) {
    if (tag.contains('Addition')) {
      return '+';
    } else if (tag.contains('Subtraction')) {
      return '-';
    } else if (tag.contains('Multiplication')) {
      return 'x';
    } else if (tag.contains('Division')) {
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

List<String> getSetOptions(String factType) {
  switch (factType) {
    case MathFactTypes.Subtraction:
      return [
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
    break;

    case MathFactTypes.Multiplication: 
      return [
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
    break;

    case MathFactTypes.Division: 
      return [
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
    break;

    default: //MathFactTypes.Addition: 
      return [
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
        '17',
        '18', // P1 in study 1
        '19'  // P2 in study 1
      ];
    break;
  }
}

class ErrorFeedback {
  static const String EachTrialAlways = "Each Trial Always";
  static const String EachErredTrial = "Each Erred Trial";
  static const String NoErrorFeedback = "No Error Feedback";

  static const List<String> FeedbackOptions = [
    ErrorFeedback.EachTrialAlways,
    ErrorFeedback.EachErredTrial,
    ErrorFeedback.NoErrorFeedback
  ];
}

class Landing {
  static const String Title = "Cover, Copy, Compare";
  static const String Description =
      "\nShawn Gilroy, Louisiana State University (2018-2019)\n\nBehavioral Engineering Lab\n\nMIT-Licensed (Version:";
}

class HelpText {
  static const String HelpGuidelines = "App Usage Guidelines";
  static const String HelpAddingStudents = "Adding a New Student to Group/Class";
  static const String HelpAddingStudentsDesc =
      "Students can be easily added to the dashboard by selected the button with the '+' symbol on the home screen. From there, you can supply a name for the student, which types of tasks to assign (e.g., math facts, addition), which sets of items to assign (18 variations are included), how many problems to present from the set, whether to randomize which items in the set are present, whether to present problems vertically or horizontally, and whether to focus on accuracy or fluency.";
  static const String HelpClassroom = "Editing Personal Settings (Classroom)";
  static const String HelpClassroomDesc =
      "At any time, you can edit your personal settings (e.g., name, school) by pressing the settings button in the appbar. The settings button in the appbar pertains to the teacher, while the settings button in the student area refers to respective students.";
  static const String HelpSettings = "Editing a Student's Assigned Programming (In-App)";
  static const String HelpSettingsDesc =
      "It is likely that, over time, you may choose to update a student's current programming (e.g., changing from a focus on accuracy, to fluency for addition math facts). Settings for an individual student can be done by pressing the settings icon for the respective student. From this menu, you will be able to modify both the skill targeted as well as how Cover Copy Compare will be presented.";
  static const String HelpView = "Viewing a Student's Progress (In-App)";
  static const String HelpViewDesc =
      "Student progress is updated in realtime and can be viewed in the app by pressing the red charting button to the right of the student's information. This will bring up a visual chart of the student's performance, highlight the specific type of data being targeted (e.g., Accuracy for Math Facts Addition, fluency for Math Facts Subtraction). Additionally, the aimline designated for the student will be drawn atop of their current programming.";
  static const String HelpRemote = "Working with the App Remotely (Via Website)";
  static const String HelpRemoteDesc1 =
      "Occasionally, teachers/team leaders may find it easier to manage student programming remotely (i.e., not having to update individually using a tablet). Teachers/team leaders may log into their account at the following location: ";
}
