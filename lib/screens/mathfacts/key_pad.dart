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

import 'package:covcopcomp_math_fact/shared/themes.dart';
import 'package:flutter/material.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({Key key, this.appendInput, this.readyForEntry}) : super(key: key);

  final ValueSetter<String> appendInput;
  final bool readyForEntry;

  Widget _createKey(String code) {
    return Expanded(
        child: TextButton(
      onPressed: () => appendInput(code),
      style: readyForEntry ? AppThemes.KeypadButtonStyle : 
      TextButton.styleFrom(backgroundColor: Colors.green[50], 
                           primary: Colors.white),
      child: Text(
        code,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 42.0),
      ),
    ));
  }

  Widget _createDeleteKey(String code) {
    return Expanded(
        child: TextButton(
      onPressed: () => appendInput(code),
      style: readyForEntry ? 
        TextButton.styleFrom(backgroundColor: Colors.red, 
                             primary: Colors.white) : 
        TextButton.styleFrom(backgroundColor: Colors.red[50], 
                             primary: Colors.white),
      child: Text(
        code,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 42.0),
      ),
    ));
  }

  Widget _createEqualsKey(String code) {
    return Expanded(
        child: TextButton(
      onPressed: () => appendInput(code),
      style: readyForEntry ? 
        TextButton.styleFrom(backgroundColor: Colors.blue, 
                             primary: Colors.white) : 
        TextButton.styleFrom(backgroundColor: Colors.blue[50], 
                             primary: Colors.white),
      child: Text(
        code,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 42.0),
      ),
    ));
  }

  Widget _createOperatorKey(String code) {
    return Expanded(
        child: TextButton(
      onPressed: () => appendInput(code),
      style: readyForEntry ? 
        TextButton.styleFrom(backgroundColor: Colors.purple, 
                             primary: Colors.white) : 
        TextButton.styleFrom(backgroundColor: Colors.purple[50], 
                             primary: Colors.white),
      child: Text(
        code,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 42.0),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {

    const sizedBox10 = SizedBox(height: 10.0);
    const sizedBoxSides = SizedBox(width: 10.0);

    return Column(children: [
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createKey("1"),
          sizedBoxSides,
          _createKey("2"),
          sizedBoxSides,
          _createKey("3"),
          sizedBoxSides,
          _createOperatorKey("+"),
        ],
      )),
      sizedBox10,
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createKey("4"),
          sizedBoxSides,
          _createKey("5"),
          sizedBoxSides,
          _createKey("6"),
          sizedBoxSides,
          _createOperatorKey("-"),
        ],
      )),
      sizedBox10,
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createKey("7"),
          sizedBoxSides,
          _createKey("8"),
          sizedBoxSides,
          _createKey("9"),
          sizedBoxSides,
          _createOperatorKey("-"),
        ],
      )),
      sizedBox10,
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createDeleteKey("Del"),
          sizedBoxSides,
          _createKey("0"),
          sizedBoxSides,
          _createEqualsKey("="),
          sizedBoxSides,
          _createOperatorKey("/"),
        ],
      )),
    ]);
  }
}
