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

    final Widget svg1 = SvgPicture.asset('assets/Anonymous_Paper_2_icon.svg',
        width: screen.width * 0.20, height: screen.height * 0.20);

    final Widget svg2 = SvgPicture.asset(
      'assets/Anonymous_Paper_4_icon.svg',
      width: screen.width * 0.20,
      height: screen.height * 0.20,
    );

    return Container(
      decoration: const BoxDecoration(color: Colors.lightBlue),
      alignment: Alignment.center,
      child: Stack(children: [
        Positioned(
          child: svg2,
          left: centerX - iconWidth / 2.0,
          top: centerY / 2.0,
        ),
        //Positioned(
        //  child: svg1,
        //  left: centerX - iconWidth / 2.0 - iconWidth * 0.5,
        //  top: centerY / 2.0 + iconWidth * 0.1,
        //),
        const Positioned.fill(
          child: Center(
              child: Text(
            "Cover, Copy, Compare",
            style: TextStyle(
                color: Colors.white,
                decorationColor: Colors.black,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.double),
          )),
          top: 0,
          left: 0,
        ),
        Positioned.fill(
          child: Center(
              child: TextButton(
                  //style: ButtonStyle(backgroundColor: ),
                  child: const Text(
                    "Launch",
                    style: cccTextStyle,
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, "/start"))),
          left: 0,
          top: screen.height * 0.80,
        )
      ]),
    );
  }
}
