import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_factory/app/modules/login/pages/password_recovery_page.dart';
import 'package:soap_factory/app/modules/login/pages/sign_up_page.dart';
import 'package:soap_factory/app/modules/login/widgets/button_back.dart';
import 'package:soap_factory/app/modules/login/widgets/button_white.dart';
import 'package:soap_factory/app/modules/login/widgets/input_white.dart';
import 'package:soap_factory/app/modules/login/widgets/login_google.dart';

import '../widgets/login_twitter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int menu = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 40),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 30, 16, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: menuOption(this.menu),
        ),
      ),
    );
  }

  List<Widget> menuOption(int menu) {
    switch (menu) {
      case 1:
        return forgetPass();
      case 2:
        return singUp();
      default:
        return login();
    }
  }

  List<Widget> login() {
    return [
      formLogin(),
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
                menu = 2;
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
            menu = 0;
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

  List<Widget> singUp() {
    return [
      ButtonBack(() => setState(() {
            menu = 0;
          })),
      SingUpPage()
    ];
  }

  void sendLogin() {}

  Widget formLogin() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputWhite(
                labelText: "E-mail",
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.grey[200],
                )),
            InputWhite(
              isPassword: true,
              labelText: "Password",
              prefixIcon: Icon(
                Icons.vpn_key,
                color: Colors.grey[200],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        menu = 1;
                      });
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            ButtonWhite(() => sendLogin(), "Continue")
          ],
        ),
      ),
    );
  }
}
