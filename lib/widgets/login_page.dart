import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_factory/views/password_recovery_view.dart';
import 'package:soap_factory/widgets/login_google.dart';

import 'login_twitter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LoginGoogle(),
        LoginTwitter(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
          child: Divider(
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t Have An Account?',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  print("onTap called.");
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.blueAccent[800],
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        )
        //PasswordRecoveryView()
      ],
    );
  }
}
