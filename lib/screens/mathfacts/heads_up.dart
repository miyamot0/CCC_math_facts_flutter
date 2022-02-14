import 'package:flutter/material.dart';

class HeadsUpPanel extends StatelessWidget {
  const HeadsUpPanel({Key key, this.entryBarString}) : super(key: key);

  final String entryBarString;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.green),
                  child: Text(
                    'TIMER',
                    textAlign: TextAlign.center,
                  ),
                )),
            Expanded(
                flex: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.orange),
                  child: Text(
                    entryBarString ?? 'ENTRY BAR',
                    textAlign: TextAlign.center,
                  ),
                )),
            Expanded(
                flex: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'CONFIRM',
                    textAlign: TextAlign.center,
                  ),
                )),
          ],
        ));
  }
}
