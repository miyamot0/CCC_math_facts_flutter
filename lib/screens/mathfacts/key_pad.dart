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

import '../../shared/constants.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({Key key, this.appendInput}) : super(key: key);

  final ValueSetter<String> appendInput;

  Widget _createKey(String code) {
    return Expanded(
        child: TextButton(
      onPressed: () => appendInput(code),
      style: keypadButtonStyle,
      child: Text(
        code,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 42.0),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createKey("1"),
          const SizedBox(width: 5),
          _createKey("2"),
          const SizedBox(width: 5),
          _createKey("3"),
          const SizedBox(width: 5),
          _createKey("+"),
        ],
      )),
      const SizedBox(height: 5),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createKey("4"),
          const SizedBox(width: 5),
          _createKey("5"),
          const SizedBox(width: 5),
          _createKey("6"),
          const SizedBox(width: 5),
          _createKey("-"),
        ],
      )),
      const SizedBox(height: 5),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createKey("7"),
          const SizedBox(width: 5),
          _createKey("8"),
          const SizedBox(width: 5),
          _createKey("9"),
          const SizedBox(width: 5),
          _createKey("-"),
        ],
      )),
      const SizedBox(height: 5),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createKey("Del"),
          const SizedBox(width: 5),
          _createKey("0"),
          const SizedBox(width: 5),
          _createKey("="),
          const SizedBox(width: 5),
          _createKey("/"),
        ],
      )),
    ]);
  }
}
