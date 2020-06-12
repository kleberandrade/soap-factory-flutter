import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:soap_factory/app/modules/login/controllers/password_recovery/password_recovery_store.dart';
import 'package:soap_factory/app/modules/login/widgets/button_white.dart';
import 'package:soap_factory/app/modules/login/widgets/input_white.dart';

class PasswordRecoveryView extends StatefulWidget {
  @override
  _PasswordRecoveryViewState createState() => _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends State<PasswordRecoveryView> {
  final TextEditingController _emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  PasswordRecoveryStore passwordRecoveryStore;
  ReactionDisposer reactionDisposer;

  void sendForgetPassword() {
    if (_formKey.currentState.validate())
      passwordRecoveryStore.sendPasswordRecovery(
          passwordRecoveryStore.userEmail, _onSuccess, (errorMessage) {
        _onError(errorMessage);
        return null;
      });
  }

  @override
  Widget build(BuildContext context) {
    print(passwordRecoveryStore);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Observer(builder: (_) {
              return InputWhite(
                labelText: "E-mail",
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          ButtonWhite(() => sendForgetPassword(), "Continue")
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    passwordRecoveryStore = Provider.of<PasswordRecoveryStore>(context);
  }

  @override
  void dispose() {
    reactionDisposer();
    super.dispose();
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'E-mail enviado com sucesso!',
      ),
      backgroundColor: Colors.green[400],
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      print('foi');
    });
  }

  void _onError(String errorMessage) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Erro ao enviar E-mail! $errorMessage',
      ),
      backgroundColor: Colors.red[400],
      duration: Duration(seconds: 3),
    ));
  }
}
