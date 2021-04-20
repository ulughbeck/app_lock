import 'package:flutter/material.dart';

@immutable
class ErrorMessage extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;

  const ErrorMessage(
    this.text, {
    Key? key,
    this.style,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: style ??
            Theme.of(context).textTheme.headline6?.copyWith(color: color),
      );
}
