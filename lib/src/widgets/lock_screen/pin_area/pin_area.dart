import 'package:flutter/widgets.dart';

import '../../../controller/controller.dart';
import '../../../theme/decoration.dart';
import '../../bloc_widgets/bloc_consumer.dart';
import 'pin_field.dart';

///
class PinArea extends StatelessWidget {
  /// [PinField] decoration
  final PinFieldDecoration decoration;

  /// Creates [PinArea]
  const PinArea({
    Key? key,
    required this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LockStateConsumer(
        builder: (context, state) {
          final pinLength = state.config.pinLength;
          return Wrap(
            spacing: decoration.spacing,
            runSpacing: decoration.spacing,
            children: <Widget>[
              for (int i = 0; i < pinLength; i++)
                PinField(
                  size: decoration.size,
                  color: _buildFieldColor(i, state),
                  borderRadius: decoration.borderRadius,
                ),
            ],
          );
        },
      );

  /// returns [Color] of pin by [index] according to state
  Color _buildFieldColor(int index, LockScreenState state) {
    if (state.isBadAttempt) return decoration.errorColor;

    final value = state.pinValue;
    if (value.isEmpty) return decoration.emptyColor;

    if (index < value.length) {
      return decoration.fillColor;
    } else {
      return decoration.emptyColor;
    }
  }
}
