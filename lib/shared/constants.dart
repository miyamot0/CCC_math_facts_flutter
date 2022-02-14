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
