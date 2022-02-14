import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class HeadsUpPanel extends StatelessWidget {
  const HeadsUpPanel(
      {Key key,
      this.viewPanelString,
      this.entryPanelString,
      this.buttonText,
      this.entryPanelColor,
      this.viewPanelColor,
      this.viewPanelText,
      this.toggleEntry,
      this.hudStatus})
      : super(key: key);

  final String viewPanelString;
  final String entryPanelString;
  final String buttonText;
  final Color entryPanelColor;
  final Color viewPanelColor;
  final Color viewPanelText;
  final Function toggleEntry;
  final CCCStatus hudStatus;

  @override
  Widget build(BuildContext context) {
    Widget _advanceButton() {
      return TextButton(
          onPressed: toggleEntry,
          style: TextButton.styleFrom(
              primary: Colors.white, backgroundColor: Colors.blue),
          child: Text(buttonText,
              style: cccTextStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: 24.0)));
    }

    return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: viewPanelColor,
                    border: Border.all(color: Colors.black)),
                child: Center(
                    child: Text(
                  viewPanelString,
                  textAlign: TextAlign.center,
                  style: cccTextStyle.copyWith(color: viewPanelText),
                )),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: entryPanelColor,
                    border: Border.all(color: Colors.black)),
                child: Center(
                    child: Text(
                  entryPanelString,
                  textAlign: TextAlign.center,
                  style: cccTextStyle,
                )),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: _advanceButton(),
            ),
          ],
        ));
  }
}
