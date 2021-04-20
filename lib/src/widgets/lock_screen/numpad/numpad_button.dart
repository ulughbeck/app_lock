import 'package:flutter/material.dart';

/// Numpad button
class NumPadButton extends StatelessWidget {
  /// child widget
  final Widget child;

  /// button height
  final double height;

  /// buton width
  final double width;

  /// callback to be executed on button tap
  final VoidCallback onPressed;

  /// callback to be executed on button long press
  final VoidCallback? onLongPressed;

  /// background color of the button
  final Color? backgroundColor;

  /// button shape
  final OutlinedBorder? shape;

  const NumPadButton({
    required this.child,
    required this.onPressed,
    required this.height,
    required this.width,
    Key? key,
    this.shape,
    this.onLongPressed,
    this.backgroundColor,
  }) : super(key: key);

  /// creates Numpad button with text
  factory NumPadButton.text(
    String text, {
    required VoidCallback onTap,
    required double width,
    required double height,
    TextStyle? textStyle,
    VoidCallback? onLongPress,
    Color? backgroundColor,
    OutlinedBorder? shape,
    Key? key,
  }) =>
      NumPadButton(
        key: key,
        onPressed: onTap,
        onLongPressed: onLongPress,
        backgroundColor: backgroundColor,
        shape: shape,
        height: height,
        width: width,
        child: Text(
          text,
          style: textStyle,
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: shape,
          ),
          onPressed: onPressed,
          onLongPress: onLongPressed,
          child: child,
        ),
      );
}
