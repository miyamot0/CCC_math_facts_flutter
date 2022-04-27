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

import 'dart:ui';

import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:covcopcomp_math_fact/shared/themes.dart';

import 'package:flutter/material.dart';

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

  final List<InlineSpan> viewPanelString;
  final List<InlineSpan> entryPanelString;
  final String buttonText;
  final Color entryPanelColor;
  final Color viewPanelColor;
  final Color viewPanelText;
  final ValueSetter<BuildContext> toggleEntry;
  final CCCStatus hudStatus;

  static const sizedBox10 = SizedBox(
    width: 10,
  );

  @override
  Widget build(BuildContext context) {
    Widget _advanceButton(BuildContext context) {
      return TextButton(
          onPressed: () => toggleEntry(context),
          style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.blue),
          child: Text(buttonText,
              style: AppThemes.PrimaryTextStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: 24.0, fontFeatures: [const FontFeature.tabularFigures()])));
    }

    Widget _generateHUDforVerticalDisplay() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(color: viewPanelColor, border: Border.all(color: Colors.black)),
              child: Center(
                  child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                    children: viewPanelString,
                    style: AppThemes.PrimaryTextStyle.copyWith(
                        color: viewPanelText,
                        fontFamily: 'RobotoMono',
                        fontFeatures: [const FontFeature.tabularFigures()])),
              )),
            ),
          ),
          sizedBox10,
          Expanded(
            flex: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(color: entryPanelColor, border: Border.all(color: Colors.black)),
              child: Center(
                  child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                    children: entryPanelString,
                    style: AppThemes.PrimaryTextStyle.copyWith(
                        color: Colors.black,
                        fontFamily: 'RobotoMono',
                        fontFeatures: [const FontFeature.tabularFigures()])),
              )),
            ),
          ),
          sizedBox10,
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _advanceButton(context),
                  flex: 1,
                ),
                sizedBox10,
                Expanded(
                  child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black))),
                  flex: 1,
                ),
                sizedBox10,
                Expanded(
                  child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black))),
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Expanded(flex: 3, child: _generateHUDforVerticalDisplay());
  }
}
