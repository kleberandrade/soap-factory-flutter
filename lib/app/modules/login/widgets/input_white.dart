import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_factory/app/shared/widgets/input_default.dart';

class InputWhite extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String error;
  final bool isPassword;
  final bool passwordVisible;
  final Function validator;
  final Function onSaved;
  final TextInputType keyboardType;
  final Widget prefixIcon;
  final Widget sufixIcon;
  final Function onChanged;
  final String initialValue;
  final TextEditingController controller;
  final EdgeInsets padding;
  final bool enabled;

  const InputWhite(
      {Key key,
      this.enabled,
      this.labelText,
      this.hintText,
      this.error,
      this.isPassword = false,
      this.passwordVisible,
      this.validator,
      this.onSaved,
      this.keyboardType,
      this.prefixIcon,
      this.sufixIcon,
      this.onChanged,
      this.initialValue,
      this.controller,
      this.padding = const EdgeInsets.all(4)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDefault();
  }
}
