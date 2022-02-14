import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeadsUpPanel extends StatelessWidget {
  const HeadsUpPanel({Key key, this.entryBarDynamic}) : super(key: key);

  final List<String> entryBarDynamic;

  @override
  Widget build(BuildContext context) {
    int len = entryBarDynamic == null ? 0 : entryBarDynamic.length;

    return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
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
              child: ListView.builder(
                  itemCount: len,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SvgPicture.asset(
                      "assets/images/${entryBarDynamic[index]}",
                      fit: BoxFit.contain,
                      width: 50,
                    );
                  }),
            ),
            const Expanded(
              flex: 1,
              child: TextButton(
                  //onPressed: () {},
                  //style: TextButton.styleFrom(primary: Colors.white),
                  //onPressed: () { print("Confirm")},
                  child: Text('Confirm')),
            ),
          ],
        ));
  }
}
