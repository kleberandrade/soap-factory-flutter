import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool isObscure;
  final IconData icon;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String labelText;
  final String initialValue;
  final String Function(String) validateText;
  final TextInputType keyboardType;
  final Widget suffixIcon;
  final TextCapitalization textCapitalization;

  InputField({
    Key key,
    this.hint,
    this.isObscure,
    this.icon,
    this.controller,
    this.onChanged,
    this.labelText,
    this.validateText,
    this.keyboardType,
    this.suffixIcon,
    this.textCapitalization,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: initialValue,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      keyboardType: keyboardType ?? TextInputType.text,
      style: TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: suffixIcon,
          hintText: hint,
          labelText: labelText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            //  when the TextFormField in unfocused
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in focused
          ),
          border: UnderlineInputBorder()),
      obscureText: isObscure ?? false,
      validator: validateText,
    );
  }
}
