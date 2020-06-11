import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_factory/app/shared/widgets/input_default.dart';

class ButtonBack extends StatelessWidget {
  final Function funcBack;

  ButtonBack(this.funcBack);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_back),
              color: Colors.blue,
              onPressed: funcBack,
            ),
          ),
        ),
      ],
    );
  }
}
