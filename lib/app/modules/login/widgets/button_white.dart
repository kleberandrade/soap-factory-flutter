import 'package:flutter/material.dart';

class ButtonWhite extends StatelessWidget {
  Function onPressed;
  String text;

  ButtonWhite(this.onPressed, this.text);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue,
      onPressed: this.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Text(
          this.text,
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
