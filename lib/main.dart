import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soap_factory/app/modules/login/animated/bubbles_animated.dart';
import 'package:soap_factory/app/modules/login/animated/wave_animated.dart';
import 'package:soap_factory/app/modules/login/controllers/password_recovery/password_recovery_store.dart';

import 'app/modules/login/pages/login_page.dart';

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
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "lib/assets/images/logo.png",
                  width: 200,
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: new SliverChildListDelegate([
//            Stack(children: <Widget>[
//              Positioned.fill(child: Bubbles(5)),
//            ]),
            AnimatedWave(height: 150, speed: 0.7, offset: 3.14),
            AnimatedCrossFade(
              duration: Duration(seconds: 1),
              firstChild: Container(
                color: Colors.blue,
              ),
              secondChild: Container(color: Colors.blue, child: LoginPage()),
              crossFadeState: !splash
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            )
          ]),
        )
      ],
    ));
  }
}

//
//child: Column(
//mainAxisAlignment: MainAxisAlignment.end,
//crossAxisAlignment: CrossAxisAlignment.stretch,
//children: [

//Expanded(
//flex: 1,
//child: Stack(children: <Widget>[
//Positioned.fill(child: Bubbles(5)),
//]),
//),
//AnimatedOpacity(
//opacity: splash ? 1.0 : 0.0,
//duration: Duration(seconds: 2),
//child: Row(
//mainAxisAlignment: MainAxisAlignment.end,
//children: [
//Image.asset(
//"lib/assets/images/logo.png",
//width: splash ? 300 : 0,
//),
//],
//),
//),
//AnimatedWave(height: 150, speed: 0.7, offset: 3.14),
//AnimatedCrossFade(
//duration: Duration(seconds: 1),
//firstChild: Container(
//color: Colors.blue,
//),
//secondChild: Container(color: Colors.blue, child: LoginPage()),
//crossFadeState: !splash
//? CrossFadeState.showSecond
//    : CrossFadeState.showFirst,
//)
//],
//)
