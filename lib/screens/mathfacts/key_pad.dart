import 'package:flutter/material.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("1", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("2", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("3", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("+", textAlign: TextAlign.center),
          )),
        ],
      )),
      const SizedBox(height: 5),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("4", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("5", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("6", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("-", textAlign: TextAlign.center),
          )),
        ],
      )),
      const SizedBox(height: 5),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("7", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("8", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("9", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("X", textAlign: TextAlign.center),
          )),
        ],
      )),
      const SizedBox(height: 5),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("Del", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("0", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("=", textAlign: TextAlign.center),
          )),
          const SizedBox(width: 5),
          Expanded(
              child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, primary: Colors.white),
            child: const Text("/", textAlign: TextAlign.center),
          )),
        ],
      )),
    ]);
  }
}
