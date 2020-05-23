import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soap_factory/pages/first_screen.dart';
import 'package:soap_factory/repository/google_login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(      
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[      
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return FlatButton.icon(
      color: Colors.red,
      textColor: Colors.white,
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: FaIcon(FontAwesomeIcons.google),
       ),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            "Login with Google",
          ),
      ),
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FirstScreen();
              },
            ),
          );
        });
      },     
    );
  }
}