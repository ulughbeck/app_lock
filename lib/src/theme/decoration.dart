import 'package:flutter/widgets.dart';

///
class LockScreenDecoration {
  /// Background color of Lock Screen
  final Color backgroundColor;

  /// Background Widget of Lock Screen
  final Widget? background;

  /// Title [TextStyle]
  final TextStyle? titleTextStyle;

  /// Error text style
  final TextStyle? errorTextStyle;

  /// Lock Screen Numpad decoration
  final NumpadDecoration numPadDecoration;

  /// Lock Screen PIN indicators decoration
  final PinFieldDecoration pinFieldDecoration;

  const LockScreenDecoration({
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.background,
    this.titleTextStyle,
    this.errorTextStyle,
    this.numPadDecoration = const NumpadDecoration(),
    this.pinFieldDecoration = const PinFieldDecoration(),
  });
}

///
class PinFieldDecoration {
  /// size of PIN indicators
  final double size;

  /// spacing between PIN indicators
  final double spacing;

  /// color of PIN indicator when it has value
  final Color fillColor;

  /// color of PIN indicator when it has no value
  final Color emptyColor;

  /// color of PIN indicators when PIN is incorrect
  final Color errorColor;

  /// radius of PIN indicators
  final BorderRadius borderRadius;

  const PinFieldDecoration({
    this.size = 12,
    this.spacing = 10,
    this.fillColor = const Color(0xFFFFFFFF),
    this.emptyColor = const Color(0xFF000000),
    this.errorColor = const Color(0xFFF44336),
    this.borderRadius = const BorderRadius.all(Radius.zero),
  });
}

///
class NumpadDecoration {
  /// background color of Numpad
  final Color backgroundColor;

  /// background color of numpad button
  final Color itemColor;

  /// text style of numpad numbers
  final TextStyle textStyle;

  /// shape of numpad button
  final OutlinedBorder btnShape;

  /// numpad button width
  final double buttonWidth;

  /// numpad button height
  final double buttonHeight;

  const NumpadDecoration({
    this.buttonWidth = 70,
    this.buttonHeight = 70,
    this.backgroundColor = const Color(0xFF9E9E9E),
    this.itemColor = const Color(0xFFFFFFFF),
    this.btnShape = const RoundedRectangleBorder(),
    this.textStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  });
}
