import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soap_factory/stores/passwordrecovery/password_recovery_store.dart';

import 'animated/bubbles_animated.dart';
import 'animated/wave_animated.dart';
import 'widgets/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PasswordRecoveryStore>(
        create: (_) => PasswordRecoveryStore(),
        child: MaterialApp(
            theme: ThemeData(primarySwatch: Colors.blue),
            title: 'Soap Factory',
            debugShowCheckedModeBanner: false,
            home: SplashScreen()));
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
          AnimatedCrossFade(
            duration: Duration(seconds: 1),
            firstChild: Container(
              color: Colors.blue,
            ),
            secondChild: Container(
                width: double.infinity, color: Colors.blue, child: LoginPage()),
            crossFadeState:
                !splash ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          )
        ],
      ),
    );
  }
}
