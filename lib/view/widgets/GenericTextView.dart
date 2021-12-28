import 'package:flutter/material.dart';

class GenericTextView extends StatelessWidget {
  final label;
  final Color color;
  final double fontSize;
  final FontWeight? fontWeight;

  GenericTextView(this.label, this.color, this.fontSize, {this.fontWeight});
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
          TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
