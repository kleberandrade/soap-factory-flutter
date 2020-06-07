import 'package:mobx/mobx.dart';
import 'package:soap_factory/repository/email_login.dart';

part 'password_email_store.g.dart';

class PasswordEmailStore = _PasswordEmailBase with _$PasswordEmailStore;

abstract class _PasswordEmailBase with Store {
AccountRepository _repository;

  _AccountControllerBase() {
    _repository = new AccountRepository();
  }

  @observable
  bool busy = false;

  @observable
  String userName = "";

  @observable
  String userEmail = '';

  @computed
  bool get isEmailValid => RegExp(
          r'^[a-zA-Z0-9-_.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
      .hasMatch(userEmail);

  @observable
  String userPassword = '';

  @computed
  bool get isPasswordValid => RegExp(
    r'^.{6,}$').hasMatch(userPassword);

  @action
  void setBusy(bool value) => busy = value;

  @action
  void setEmail(String value) => userEmail = value;

  @action
  void setPassword(String value) => userPassword = value;

  @action
  void setName(String value) => userName = value;

  @action
  Future signInWithCredentials(
      {Function onSuccess, Function(String) onError}) async {
    setBusy(true);
    _repository
        .signInWithCredentials(email: userEmail, password: userPassword)
        .then((value) => onSuccess())
        .catchError(onError)
        .whenComplete(() => setBusy(false));
  }

  @action
  Future signUpWithCredentials(
      {Function onSuccess, Function(String) onError}) async {
    setBusy(true);
    _repository
        .createUserWithEmailAndPassword(
            email: userEmail, password: userPassword, name: userName)
        .then((value) => onSuccess())
        .catchError(onError)
        .whenComplete(() => setBusy(false));
  }

  @action
  Future sendPasswordResetEmail(
      {Function onSuccess, Function(String) onError}) async {
    setBusy(true);
    _repository
        .sendPasswordResetEmail(email: userEmail)
        .then((value) => onSuccess())
        .catchError(onError)
        .whenComplete(() => setBusy(false));
  }

  @action
  Future signOut() async{
    await _repository.signOut();
  }
}