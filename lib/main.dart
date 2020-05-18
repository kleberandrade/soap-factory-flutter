import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soap_factory/stores/passwordrecovery/password_recovery_store.dart';
import 'package:soap_factory/views/password_recovery_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PasswordRecoveryStore>(
      create: (_) => PasswordRecoveryStore(),
      child: MaterialApp(
        title: 'Soap Factory',
        debugShowCheckedModeBanner: false,
        home: PasswordRecoveryView(),
      ),
    );
  }
}
