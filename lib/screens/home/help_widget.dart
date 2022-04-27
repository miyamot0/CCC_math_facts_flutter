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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({Key key}) : super(key: key);

  static const SizedBox sizedBox15 = SizedBox(
    height: 15.0,
  );

  static const SizedBox sizedBox30 = SizedBox(
    height: 30.0,
  );

  static const TextStyle titleStyle =
      TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline);

  static const TextStyle bodyStyle = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        const Text(
          HelpText.HelpGuidelines,
          style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        ),
        sizedBox30,
        const Text(
          HelpText.HelpAddingStudents,
          style: titleStyle,
        ),
        sizedBox15,
        const Text(HelpText.HelpAddingStudentsDesc, style: bodyStyle),
        sizedBox30,
        const Text(
          HelpText.HelpClassroom,
          style: titleStyle,
        ),
        sizedBox15,
        const Text(HelpText.HelpClassroomDesc, style: bodyStyle),
        sizedBox30,
        const Text(
          HelpText.HelpSettings,
          style: titleStyle,
        ),
        sizedBox15,
        const Text(HelpText.HelpSettingsDesc, style: bodyStyle),
        sizedBox30,
        const Text(
          HelpText.HelpView,
          style: titleStyle,
        ),
        sizedBox15,
        const Text(HelpText.HelpViewDesc, style: bodyStyle),
        sizedBox30,
        const Text(
          HelpText.HelpRemote,
          style: titleStyle,
        ),
        sizedBox15,
        RichText(
            text: TextSpan(children: [
          const TextSpan(text: HelpText.HelpRemoteDesc1, style: bodyStyle),
          TextSpan(
              text: 'https://miyamot0.github.io/ccc_math_facts.github.io/',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 18.0,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  try {
                    await launch("https://miyamot0.github.io/ccc_math_facts.github.io/");
                  } catch (e) {
                    //print(e.toString());
                  }
                })
        ])),
        sizedBox15,
      ],
    );
  }
}
