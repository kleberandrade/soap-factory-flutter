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
  final TextEditingController controller;
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
      this.onChanged,
      this.controller,
      this.sufixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: this.isPassword,
      cursorColor: Colors.white10,
      decoration: InputDecoration(
        suffixIcon: this.sufixIcon,
        prefixIcon: this.prefixIcon,
        labelStyle:
            TextStyle(color: Colors.grey[300], decorationColor: Colors.white70),
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.white),
        labelText: this.labelText,
        focusColor: Colors.white,
        hoverColor: Colors.white,
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}
