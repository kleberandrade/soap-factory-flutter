import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:soap_factory/strings/strings.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class LoginTwitter extends StatefulWidget {
  @override
  _LoginTwitterState createState() => _LoginTwitterState();
}

class _LoginTwitterState extends State<LoginTwitter> {
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

    setState(() {
      if (_twitterLoginStatus == TwitterLoginStatus.loggedIn &&
          _currentUser != null) {
        _loggedInMessage = '$snackBarMessage ${_currentUser.displayName}';
      } else {
        _loggedInMessage = _loggedInMessage = '$snackBarMessage';
      }
    });
  }

  void _checkCurrentUser() async {
    _currentUser = await _firebaseAuth.currentUser();
    _currentUser?.getIdToken(refresh: true);
    print(_currentUser);

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
    return Center(
        child: Container(
      padding:
          EdgeInsets.only(top: 64.0, bottom: 64.0, left: 16.0, right: 16.0),
      child: RaisedButton(
          color: Color.fromRGBO(29, 161, 242, 1.0),
          child: Row(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 16.0, right: 32.0),
                  child: Image.asset(
                    'assets/images/twitter.png',
                    height: 25.0,
                    width: 25.0,
                  )),
              Expanded(
                child: Text(
                  Strings.twitterText,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          onPressed: _handleTwitterSignIn),
    ));
  }
}
