import 'package:flutter/widgets.dart';

@immutable
class PinField extends StatelessWidget {
  final Color color;
  final double size;
  final BorderRadius? borderRadius;

  /// Creates [PinField]
  const PinField({
    required this.color,
    required this.size,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        height: size,
        width: size,
      );
}
