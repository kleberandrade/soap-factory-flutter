import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:soap_factory/stores/passwordrecovery/password_recovery_store.dart';
import 'package:soap_factory/widgets/email_form_field.dart';

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

  @override
  Widget build(BuildContext context) {
    print(passwordRecoveryStore);
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: const Text(
                'Forgot your password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: const Text(
                'Enter your email address and we will send you instructions to reset your password. ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Observer(builder: (_) {
              return InputField(
                hint: 'E-mail',
                suffixIcon: Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                labelText: 'E-mail',
                onChanged: passwordRecoveryStore.setEmail,
                validateText: (email) {
                  if (email.isEmpty ||
                      !email.contains(RegExp(
                          r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$")))
                    return 'E-mail inválido!';
                  return null;
                },
              );
            }),
            const SizedBox(height: 16),
            Container(
              height: 50,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  if (_formKey.currentState.validate())
                    passwordRecoveryStore.sendPasswordRecovery(
                        passwordRecoveryStore.userEmail, _onSuccess,
                        (errorMessage) {
                      _onError(errorMessage);
                      return null;
                    });
                },
                child: Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        ),
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
