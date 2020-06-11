// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_email_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PasswordEmailStore on _PasswordEmailBase, Store {
  Computed<bool> _$isEmailValidComputed;

  @override
  bool get isEmailValid =>
      (_$isEmailValidComputed ??= Computed<bool>(() => super.isEmailValid,
              name: '_PasswordEmailBase.isEmailValid'))
          .value;
  Computed<bool> _$isPasswordValidComputed;

  @override
  bool get isPasswordValid =>
      (_$isPasswordValidComputed ??= Computed<bool>(() => super.isPasswordValid,
              name: '_PasswordEmailBase.isPasswordValid'))
          .value;

  final _$busyAtom = Atom(name: '_PasswordEmailBase.busy');

  @override
  bool get busy {
    _$busyAtom.reportRead();
    return super.busy;
  }

  @override
  set busy(bool value) {
    _$busyAtom.reportWrite(value, super.busy, () {
      super.busy = value;
    });
  }

  final _$userNameAtom = Atom(name: '_PasswordEmailBase.userName');

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_PasswordEmailBase.userEmail');

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

  final _$userPasswordAtom = Atom(name: '_PasswordEmailBase.userPassword');

  @override
  String get userPassword {
    _$userPasswordAtom.reportRead();
    return super.userPassword;
  }

  @override
  set userPassword(String value) {
    _$userPasswordAtom.reportWrite(value, super.userPassword, () {
      super.userPassword = value;
    });
  }

  final _$signInWithCredentialsAsyncAction =
      AsyncAction('_PasswordEmailBase.signInWithCredentials');

  @override
  Future<dynamic> signInWithCredentials(
      {Function onSuccess, dynamic Function(String) onError}) {
    return _$signInWithCredentialsAsyncAction.run(() =>
        super.signInWithCredentials(onSuccess: onSuccess, onError: onError));
  }

  final _$signUpWithCredentialsAsyncAction =
      AsyncAction('_PasswordEmailBase.signUpWithCredentials');

  @override
  Future<dynamic> signUpWithCredentials(
      {Function onSuccess, dynamic Function(String) onError}) {
    return _$signUpWithCredentialsAsyncAction.run(() =>
        super.signUpWithCredentials(onSuccess: onSuccess, onError: onError));
  }

  final _$sendPasswordResetEmailAsyncAction =
      AsyncAction('_PasswordEmailBase.sendPasswordResetEmail');

  @override
  Future<dynamic> sendPasswordResetEmail(
      {Function onSuccess, dynamic Function(String) onError}) {
    return _$sendPasswordResetEmailAsyncAction.run(() =>
        super.sendPasswordResetEmail(onSuccess: onSuccess, onError: onError));
  }

  final _$signOutAsyncAction = AsyncAction('_PasswordEmailBase.signOut');

  @override
  Future<dynamic> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  final _$_PasswordEmailBaseActionController =
      ActionController(name: '_PasswordEmailBase');

  @override
  void setBusy(bool value) {
    final _$actionInfo = _$_PasswordEmailBaseActionController.startAction(
        name: '_PasswordEmailBase.setBusy');
    try {
      return super.setBusy(value);
    } finally {
      _$_PasswordEmailBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_PasswordEmailBaseActionController.startAction(
        name: '_PasswordEmailBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_PasswordEmailBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_PasswordEmailBaseActionController.startAction(
        name: '_PasswordEmailBase.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_PasswordEmailBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setName(String value) {
    final _$actionInfo = _$_PasswordEmailBaseActionController.startAction(
        name: '_PasswordEmailBase.setName');
    try {
      return super.setName(value);
    } finally {
      _$_PasswordEmailBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
busy: ${busy},
userName: ${userName},
userEmail: ${userEmail},
userPassword: ${userPassword},
isEmailValid: ${isEmailValid},
isPasswordValid: ${isPasswordValid}
    ''';
  }
}
