import 'package:align_positioned/align_positioned.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    double centerX = screen.width / 2.0;
    double centerY = screen.height / 2.0;
    final double iconWidth = screen.width * 0.20;

    final Widget svg1 = SvgPicture.asset('assets/coloured_paper.svg',
        width: screen.width * 0.20, height: screen.height * 0.20);

    final Widget svg2 = SvgPicture.asset(
      'assets/new_document.svg',
      width: screen.width * 0.20,
      height: screen.height * 0.20,
    );

    return Container(
      color: Colors.lightBlue,
      child: Stack(children: [
        AlignPositioned(
          alignment: Alignment.topCenter,
          child: Row(children: [svg1, svg2]),
        ),
        const AlignPositioned(
          alignment: Alignment.center,
          child: Center(
              child: Text(
            "Cover, Copy, Compare",
            style: TextStyle(
                color: Colors.white,
                decorationColor: Colors.black,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.double),
          )),
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
                //style: MaterialButtonSty(
                //    backgroundColor: MaterialStateProperty.all(Colors.blue),
                //    foregroundColor: MaterialStateProperty.all(Colors.green)),
                //style: ButtonStyle(backgroundColor: ),
                child: Text(
                  "Launch App",
                  style: cccTextStyle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/start"))),
      ]),
    );
  }
}
