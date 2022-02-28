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

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0)));

const cccTextStyle = TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold);

ButtonStyle keypadButtonStyle =
    TextButton.styleFrom(backgroundColor: Colors.green, primary: Colors.white);

enum CCCStatus { entry, begin, coverCopy, compare }

List<String> setSizeArray = ["8", "16", "24"];

class MathFactTypes {
  // ignore: non_constant_identifier_names
  String Addition = "Math Facts-Addition";
  // ignore: non_constant_identifier_names
  String Subtraction = "Math Facts-Subtraction";
  // ignore: non_constant_identifier_names
  String Multiplication = "Math Facts-Multiplication";
  // ignore: non_constant_identifier_names
  String Division = "Math Facts-Division";
}

List<String> factsType = [
  MathFactTypes().Addition,
  MathFactTypes().Subtraction,
  MathFactTypes().Multiplication,
  MathFactTypes().Division
];

class Orientations {
  // ignore: non_constant_identifier_names
  String Vertical = "Vertical";
  // ignore: non_constant_identifier_names
  String Horizontal = "Horizontal";
  // ignore: non_constant_identifier_names
  String NoPreference = "No Preference";
}

List<String> orientationPreference = [
  Orientations().NoPreference,
  Orientations().Vertical,
  Orientations().Horizontal
];

class Metrics {
  // ignore: non_constant_identifier_names
  String Accuracy = "Accuracy";
  // ignore: non_constant_identifier_names
  String Fluency = "Fluency";
}

List<String> metricPreference = [Metrics().Accuracy, Metrics().Fluency];
