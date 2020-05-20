import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:soap_factory/animated/bubbles_animated.dart';
import 'package:soap_factory/animated/wave_animated.dart';
import 'package:soap_factory/widgets/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SplashScreen> {
  bool splash = true;
  double height = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        splash = false;
        height = 450;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 16, 0),
            child: AnimatedOpacity(
              opacity: splash ? 0 : 1.0,
              duration: Duration(seconds: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(children: <Widget>[
              Positioned.fill(child: Bubbles(5)),
            ]),
          ),
          AnimatedOpacity(
            opacity: splash ? 1.0 : 0.0,
            duration: Duration(seconds: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: splash ? 300 : 0,
                ),
              ],
            ),
          ),
          AnimatedWave(height: 150, speed: 0.7, offset: 3.14),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: !splash
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 10),
                    child: LoginPage(),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
