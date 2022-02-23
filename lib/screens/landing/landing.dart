import 'package:align_positioned/align_positioned.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';

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

    final Widget svg1 = SvgPicture.asset('assets/coloured_paper.svg',
        width: screen.width * 0.35, height: screen.height * 0.35);

    final Widget svg2 = SvgPicture.asset(
      'assets/new_document.svg',
      width: screen.width * 0.35,
      height: screen.height * 0.35,
    );

    return FutureBuilder(
        future: loadAllReferences(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: Stack(children: [
                AlignPositioned(
                    alignment: Alignment.topCenter,
                    dy: screen.height * .1,
                    dx: screen.width * .025,
                    child: svg1),
                AlignPositioned(
                    alignment: Alignment.topCenter,
                    dy: screen.height * .075,
                    dx: -screen.width * .025,
                    child: svg2),
                AlignPositioned(
                  alignment: Alignment.center,
                  child: Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text(
                      "Cover, Copy, Compare",
                      style: TextStyle(
                          color: Colors.white,
                          decorationColor: Colors.black,
                          decoration: TextDecoration.none,
                          decorationStyle: TextDecorationStyle.double),
                    ),
                    Text(
                      "\nShawn Gilroy, Louisiana State University (2018-2019)\nBehavioral Engineering Lab\nMIT-Licensed (${appInfo.appName}:${appInfo.version})",
                      style: const TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 14.0,
                      ),
                    )
                  ])),
                ),
                AlignPositioned(
                    alignment: Alignment.bottomCenter,
                    dy: -screen.height * .05,
                    child: MaterialButton(
                        color: Colors.blueAccent,
                        splashColor: Colors.redAccent,
                        textColor: Colors.white,
                        minWidth: screen.width * 0.25,
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Launch App",
                          style: cccTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, "/start"))),
              ]),
            );
          } else {
            return Container();
          }
        });
  }
}
