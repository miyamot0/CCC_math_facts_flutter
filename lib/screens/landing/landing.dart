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

import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:avatar_glow/avatar_glow.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  PackageInfo appInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @protected
  Future<bool> loadAllReferences(BuildContext context) async {
    appInfo = await PackageInfo.fromPlatform();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    const double scaling = 0.275;
    const double strokeWidth = 4;
    const double fontSize = 20;

    final double tapButtonRadius = screen.width * 0.1;

    final Widget svg1 =
        SvgPicture.asset('assets/coloured_paper.svg', width: screen.width * scaling, height: screen.height * scaling);

    final Widget svg2 = SvgPicture.asset(
      'assets/new_document.svg',
      width: screen.width * scaling,
      height: screen.height * scaling,
    );

    return FutureBuilder(
        future: loadAllReferences(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: Stack(children: [
                AlignPositioned(
                    alignment: Alignment.topCenter, dy: screen.height * .1, dx: screen.width * .025, child: svg1),
                AlignPositioned(
                    alignment: Alignment.topCenter, dy: screen.height * .075, dx: -screen.width * .025, child: svg2),
                AlignPositioned(
                  alignment: Alignment.center,
                  dy: screen.height * .075,
                  child: Center(
                      child: Stack(
                    children: [
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          "Cover, Copy, Compare",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = strokeWidth
                                ..color = Colors.blue),
                        ),
                        Text(
                          "\nShawn Gilroy, Louisiana State University (2018-2019)\n\nBehavioral Engineering Lab\n\nMIT-Licensed (Version: ${appInfo.version})",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSize,
                              decoration: TextDecoration.none,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = strokeWidth
                                ..color = Colors.blue),
                        )
                      ]),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text(
                          "Cover, Copy, Compare",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "\nShawn Gilroy, Louisiana State University (2018-2019)\n\nBehavioral Engineering Lab\n\nMIT-Licensed (Version: ${appInfo.version})",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: fontSize,
                          ),
                        )
                      ])
                    ],
                  )),
                ),
                AlignPositioned(
                  alignment: Alignment.bottomCenter,
                  dy: -screen.height * .05,
                  child: AvatarGlow(
                    endRadius: 150,
                    animate: true,
                    glowColor: Colors.green,
                    child: Material(
                      elevation: 20.0,
                      color: Colors.greenAccent,
                      shape: const CircleBorder(),
                      child: IconButton(
                          iconSize: tapButtonRadius,
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: tapButtonRadius,
                          ),
                          onPressed: () => Navigator.pushReplacementNamed(context, "/start")),
                    ),
                  ),
                )
              ]),
            );
          } else {
            return Container();
          }
        });
  }
}
