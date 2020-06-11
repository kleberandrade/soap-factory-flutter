import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_factory/app/modules/login/pages/password_recovery_view.dart';
import 'package:soap_factory/app/modules/login/widgets/button_back.dart';
import 'package:soap_factory/app/modules/login/widgets/login_google.dart';

import 'login_twitter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool mainLogin = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 30, 16, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: mainLogin ? login() : forgetPass(),
          ),
        ),
      ),
    );
  }

  List<Widget> login() {
    return [
      LoginGoogle(),
      LoginTwitter(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
        child: Divider(
          color: Colors.white,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t Have An Account?',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              setState(() {
                mainLogin = false;
              });
            },
            child: Text(
              "Sign Up",
              style: TextStyle(
                  color: Colors.blueAccent[800],
                  decoration: TextDecoration.underline),
            ),
          )
        ],
      )
      //PasswordRecoveryView()
    ];
  }

  List<Widget> forgetPass() {
    return [
      ButtonBack(() => setState(() {
            mainLogin = true;
          })),
      Text(
        'Forgot your password?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          'Enter your email address and we will send you instructions to reset your password. ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      PasswordRecoveryView()
    ];
  }
}
