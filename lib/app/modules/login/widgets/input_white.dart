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
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: this.prefixIcon,
        prefixStyle: TextStyle(
            color: Colors.white,
            decorationColor: Colors.white,
            backgroundColor: Colors.white),
        labelStyle:
            TextStyle(color: Colors.white, decorationColor: Colors.white),
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
