import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soap_factory/pages/first_screen.dart';
import 'package:soap_factory/repository/google_login.dart';
import 'package:soap_factory/strings/strings.dart';
import 'package:toast/toast.dart';

class LoginGoogle extends StatefulWidget {
  @override
  _LoginGoogleState createState() => _LoginGoogleState();
}

class _LoginGoogleState extends State<LoginGoogle> {
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      color: Color(0xFFCA4534),
      textColor: Colors.white,
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: FaIcon(FontAwesomeIcons.google),
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
