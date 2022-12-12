import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  const Heading(
    this._text, {
    Key? key,
    this.paddingLeft,
  }) : super(key: key);

  final String _text;
  final double? paddingLeft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: paddingLeft ?? 20),
      child: Text(
        _text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
