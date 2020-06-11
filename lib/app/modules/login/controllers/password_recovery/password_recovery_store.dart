import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'password_recovery_controller.g.dart';

class PasswordRecoveryStore = _PasswordRecoveryBase with _$PasswordRecovery;

abstract class _PasswordRecoveryBase with Store {
  @observable
  String passwordRecoveryMessage = '';

  @observable
  FirebaseAuth _auth = FirebaseAuth.instance;

  @observable
  String userEmail = '';

  @computed
  bool get isEmailValid => RegExp(
          r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$")
      .hasMatch(userEmail);

  @action
  void setEmail(String value) => userEmail = value;

  @action
  void sendPasswordRecovery(String email, VoidCallback onSuccess,
      Function(String) onError(String errorMessage)) {
    _auth.sendPasswordResetEmail(email: userEmail).then((_) {
      onSuccess();
    }).catchError((e) {
      switch (e.code) {
        case 'ERROR_USER_NOT_FOUND':
          passwordRecoveryMessage =
              'O usuário não foi encontrado no nosso banco de dados!';
      }
      onError(passwordRecoveryMessage);
    });
  }
}
