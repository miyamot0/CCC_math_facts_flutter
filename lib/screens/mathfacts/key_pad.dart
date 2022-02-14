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
