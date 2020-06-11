// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_recovery_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PasswordRecovery on _PasswordRecoveryBase, Store {
  Computed<bool> _$isEmailValidComputed;

  @override
  bool get isEmailValid =>
      (_$isEmailValidComputed ??= Computed<bool>(() => super.isEmailValid,
              name: '_PasswordRecoveryBase.isEmailValid'))
          .value;

  final _$passwordRecoveryMessageAtom =
      Atom(name: '_PasswordRecoveryBase.passwordRecoveryMessage');

  @override
  String get passwordRecoveryMessage {
    _$passwordRecoveryMessageAtom.reportRead();
    return super.passwordRecoveryMessage;
  }

  @override
  set passwordRecoveryMessage(String value) {
    _$passwordRecoveryMessageAtom
        .reportWrite(value, super.passwordRecoveryMessage, () {
      super.passwordRecoveryMessage = value;
    });
  }

  final _$_authAtom = Atom(name: '_PasswordRecoveryBase._auth');

  @override
  FirebaseAuth get _auth {
    _$_authAtom.reportRead();
    return super._auth;
  }

  @override
  set _auth(FirebaseAuth value) {
    _$_authAtom.reportWrite(value, super._auth, () {
      super._auth = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_PasswordRecoveryBase.userEmail');

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  final _$_PasswordRecoveryBaseActionController =
      ActionController(name: '_PasswordRecoveryBase');

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_PasswordRecoveryBaseActionController.startAction(
        name: '_PasswordRecoveryBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_PasswordRecoveryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sendPasswordRecovery(String email, VoidCallback onSuccess,
      dynamic Function(String) Function(String) onError) {
    final _$actionInfo = _$_PasswordRecoveryBaseActionController.startAction(
        name: '_PasswordRecoveryBase.sendPasswordRecovery');
    try {
      return super.sendPasswordRecovery(email, onSuccess, onError);
    } finally {
      _$_PasswordRecoveryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
passwordRecoveryMessage: ${passwordRecoveryMessage},
userEmail: ${userEmail},
isEmailValid: ${isEmailValid}
    ''';
  }
}
