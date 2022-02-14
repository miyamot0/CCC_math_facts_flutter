import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeadsUpPanel extends StatelessWidget {
  const HeadsUpPanel(
      {Key key,
      this.entryBarDynamic,
      this.entryPanelColor,
      this.viewPanelColor,
      this.toggleEntry,
      this.showEntry})
      : super(key: key);

  final List<String> entryBarDynamic;
  final Color entryPanelColor;
  final Color viewPanelColor;
  final Function toggleEntry;
  final bool showEntry;

  @override
  Widget build(BuildContext context) {
    int len = entryBarDynamic == null ? 0 : entryBarDynamic.length;

    return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: ColoredBox(
                color: showEntry ? viewPanelColor : entryPanelColor,
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
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 6,
              child: ColoredBox(
                color: showEntry ? entryPanelColor : viewPanelColor,
                child: const Text(""),
                /*
                ListView.builder(
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
                    */
              ),
            ),
            SizedBox(
              width: 10,
            ),
            showEntry
                ? SizedBox(
                    width: 0,
                  )
                : Expanded(
                    flex: 2,
                    child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blue),
                        //onPressed: () {},
                        //style: TextButton.styleFrom(primary: Colors.white),
                        //onPressed: () { print("Confirm")},
                        child: const Text('Check')),
                  ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: TextButton(
                  onPressed: toggleEntry,
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.green),
                  //onPressed: () {},
                  //style: TextButton.styleFrom(primary: Colors.white),
                  //onPressed: () { print("Confirm")},
                  child: const Text('Confirm')),
            ),
          ],
        ));
  }
}
