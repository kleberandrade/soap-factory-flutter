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

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class LoginGoogle extends StatefulWidget {
  @override
  _LoginGoogleState createState() => _LoginGoogleState();
}

class _LoginGoogleState extends State<LoginGoogle> {
  StreamSubscription<FirebaseUser> _listener;

  FirebaseUser _currentUser;

  TwitterLoginResult _twitterLoginResult;
  TwitterLoginStatus _twitterLoginStatus;
  TwitterSession _currentUserTwitterSession;

  String _loggedInMessage;

  void _handleTwitterSignIn() async {
    String snackBarMessage = '';

    final TwitterLogin twitterLogin = new TwitterLogin(
        consumerKey: Strings.twitterApiKey,
        consumerSecret: Strings.twitterApiSecret);

    _twitterLoginResult = await twitterLogin.authorize();
    _currentUserTwitterSession = _twitterLoginResult.session;
    _twitterLoginStatus = _twitterLoginResult.status;

    switch (_twitterLoginStatus) {
      case TwitterLoginStatus.loggedIn:
        _currentUserTwitterSession = _twitterLoginResult.session;
        snackBarMessage = 'Successfully signed in as';
        break;

      case TwitterLoginStatus.cancelledByUser:
        snackBarMessage = 'Sign in cancelled by user.';
        break;

      case TwitterLoginStatus.error:
        snackBarMessage = 'An error occurred signing with Twitter.';
        break;
    }

    AuthCredential _authCredential = TwitterAuthProvider.getCredential(
        authToken: _currentUserTwitterSession?.token ?? '',
        authTokenSecret: _currentUserTwitterSession?.secret ?? '');
    _currentUser =
        (await _firebaseAuth.signInWithCredential(_authCredential)).user;

    if (_currentUser.displayName != null) {
      snackBarMessage += " ${_currentUser.displayName}";
    }

    showToast(snackBarMessage, duration: 10, gravity: 5);
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  void _checkCurrentUser() async {
    _currentUser = await _firebaseAuth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _firebaseAuth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

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
