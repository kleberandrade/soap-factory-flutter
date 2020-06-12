import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:soap_factory/app/modules/login/controllers/password_recovery/password_recovery_store.dart';
import 'package:soap_factory/app/modules/login/widgets/button_white.dart';
import 'package:soap_factory/app/modules/login/widgets/input_white.dart';

class SingUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InputWhite(
              labelText: "E-mail",
            ),
            InputWhite(
              isPassword: true,
              labelText: "Password",
              sufixIcon: Icon(
                FontAwesomeIcons.eyeSlash,
                size: 15,
                color: Colors.white70,
              ),
            ),
            InputWhite(
              isPassword: true,
              labelText: "Confirm Password",
              sufixIcon: Icon(
                FontAwesomeIcons.eye,
                size: 15,
                color: Colors.white70,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ButtonWhite(() => newAccount(), "Sign Up")
          ],
        ),
      ),
    );
  }

  void newAccount() {}
}
