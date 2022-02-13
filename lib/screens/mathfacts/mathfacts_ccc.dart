import 'package:flutter/material.dart';

class MathFactsCCC extends StatefulWidget {
  const MathFactsCCC({Key key}) : super(key: key);

  @override
  _MathFactsCCCState createState() => _MathFactsCCCState();
}

class _MathFactsCCCState extends State<MathFactsCCC> {
  List<Object> probList = [
    [null, null, null, null, null],
    [null, null, null, null, null],
    ["3", "+", "2", "=", "5"],
    [null, null, null, null, null],
    [null, null, null, null, null],
  ];

  Column _createView(List<Object> probList) {
    int rows = probList.length;

    List<Widget> dynContainer = [];
    List<Widget> dynRows = [];

    probList.forEach((element) {
      List<Object> mod = element as List<Object>;
      print(mod);

      int len = mod.length;

      List<Widget> dynRow = [];

      for (int c = 0; c < len; c++) {
        String value = mod[c] ?? "";

        Container dynC = Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          decoration: BoxDecoration(color: Colors.white, border: Border.all()),
          height: 50,
          child: Text(value),
        );

        Expanded dyn = Expanded(
          child: dynC,
        );

        dynRow.add(dyn);
      }

      dynRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: dynRow,
      ));
    });

    //dynContainer.add(newRow);
    //print(dynRow);

    //Row newRow = Row(
    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //  children: dynRow,
    //);

    return Column(
      children: dynRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mWidget = _createView(probList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover, Copy, Compare'),
      ),
      body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /*
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  decoration:
                      BoxDecoration(color: Colors.white, border: Border.all()),
                  height: double.infinity,
                  child: const Text(""),
                ),
              ),
              */
              Expanded(
                child: mWidget,
              ),
              Expanded(
                child: Column(children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("1", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("2", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("3", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
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
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("4", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("5", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("6", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
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
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("7", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("8", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("9", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
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
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("Del", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("0", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("=", textAlign: TextAlign.center),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white),
                        child: const Text("/", textAlign: TextAlign.center),
                      )),
                    ],
                  )),
                ]),
              ),
            ],
          )),
    );
  }
}
