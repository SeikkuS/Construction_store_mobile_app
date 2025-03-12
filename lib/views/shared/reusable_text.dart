import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  const ReusableText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines = 1, // Default to 1 line
    this.overflow = TextOverflow.fade, // Default to fade
    this.textAlign = TextAlign.left,
    this.softWrap = false,
  });

  final String text;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
      style: style,
    );
  }
}
