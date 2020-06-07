import 'package:flutter/cupertino.dart';
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
      children: [LoginTwitter(), LoginGoogle(), PasswordRecoveryView()],
    );
  }
}
