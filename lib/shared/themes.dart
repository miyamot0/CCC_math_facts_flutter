// ignore_for_file: non_constant_identifier_names, constant_identifier_names

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

class AppThemes {
  static const MaterialAccentColor PrimaryButtonBackground = Colors.redAccent;
  static const MaterialAccentColor SecondaryButtonBackground = Colors.blueAccent;

  static const Color PrimaryButtonTextColor = Colors.white;

  static ThemeData CoreTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.lightBlue,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      backgroundColor: Colors.lightBlue[100]);

  static ButtonStyle AppBarButtonStyle = TextButton.styleFrom(primary: Colors.white);
  static ButtonStyle KeypadButtonStyle = TextButton.styleFrom(backgroundColor: Colors.green, primary: Colors.white);

  static ButtonStyle PrimaryButtonStyle = TextButton.styleFrom(
      primary: PrimaryButtonBackground,
      backgroundColor: PrimaryButtonBackground,
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0));
  static const TextStyle PrimaryButtonTextStyle = TextStyle(
    color: PrimaryButtonTextColor,
    fontWeight: FontWeight.normal,
    fontSize: 26.0,
  );

  static ButtonStyle SecondaryButtonStyle = TextButton.styleFrom(
      primary: SecondaryButtonBackground,
      backgroundColor: SecondaryButtonBackground,
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0));
  static const TextStyle SecondaryButtonTextStyle = TextStyle(
    color: PrimaryButtonTextColor,
    fontWeight: FontWeight.normal,
    fontSize: 26.0,
  );

  static const TextInputDecoration = InputDecoration(
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.0)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink, width: 2.0)));

  static const PrimaryTextStyle = TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold, color: Colors.white);

//  ButtonTheme(
//    buttonColor: Colors.pink,
//  );
//  ,
}
