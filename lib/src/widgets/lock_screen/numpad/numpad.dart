import 'package:flutter/material.dart';

import '../../../biometrics/platform_biometrics.dart';
import '../../../theme/decoration.dart';
import '../../bloc_widgets/bloc_consumer.dart';
import 'numpad_button.dart';

/// Lock Screen Keyboard / Numpad
class NumPad extends StatelessWidget {
  /// Numpad decoration
  final NumpadDecoration decoration;

  /// Widget to be shown on Biometrics Button
  final Widget? biometricsIcon;

  /// Widget to be shown on Remove Button
  final Widget? removeIcon;

  /// Callback on biometrics pressed
  final VoidCallback onBiometricsPressed;

  /// Callback with number key value pressed
  final ValueChanged<String> onNumberKeyPressed;

  /// Callback on remove key pressed
  final VoidCallback onRemovePressed;

  /// Callback on remove key long pressed
  final VoidCallback onRemoveLongPressed;

  /// Creates [NumPad]
  const NumPad({
    Key? key,
    required this.decoration,
    required this.onBiometricsPressed,
    required this.onNumberKeyPressed,
    required this.onRemovePressed,
    required this.onRemoveLongPressed,
    this.removeIcon,
    this.biometricsIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: decoration.backgroundColor,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _buildNumberKey('1'),
                    _buildNumberKey('4'),
                    _buildNumberKey('7'),

                    /// Biometrics button
                    LockStateConsumer(builder: (context, state) {
                      final config = state.config;
                      final isBiometricsDisaabled = !config.isBiometricsEnabled;

                      if (isBiometricsDisaabled) return const SizedBox.shrink();
                      return NumPadButton(
                        height: decoration.buttonHeight,
                        width: decoration.buttonWidth,
                        backgroundColor: decoration.backgroundColor,
                        shape: decoration.btnShape,
                        onPressed: onBiometricsPressed,
                        child: _buildBiometricsIcon(
                          config.biometricsSupportedType,
                        ),
                      );
                    }),
                  ],
                ),
                Column(
                  children: <Widget>[
                    _buildNumberKey('2'),
                    _buildNumberKey('5'),
                    _buildNumberKey('8'),
                    _buildNumberKey('0'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    _buildNumberKey('3'),
                    _buildNumberKey('6'),
                    _buildNumberKey('9'),

                    /// Remove button
                    LockStateConsumer(builder: (context, state) {
                      if (state.pinValue.isNotEmpty) {
                        return NumPadButton(
                          height: decoration.buttonHeight,
                          width: decoration.buttonWidth,
                          shape: decoration.btnShape,
                          onPressed: onRemovePressed,
                          onLongPressed: onRemoveLongPressed,
                          child: _buildRemoveIcon(),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildBiometricsIcon(PlatformBiometricsType biometricsType) {
    if (biometricsIcon != null) return biometricsIcon!;
    switch (biometricsType) {
      case PlatformBiometricsType.face:
        return Icon(
          Icons.sentiment_satisfied,
          color: decoration.itemColor,
        );
      case PlatformBiometricsType.iris:
        return Icon(
          Icons.remove_red_eye,
          color: decoration.itemColor,
        );
      case PlatformBiometricsType.fingerprint:
      default:
        return Icon(
          Icons.fingerprint,
          color: decoration.itemColor,
        );
    }
  }

  Widget _buildRemoveIcon() {
    if (removeIcon != null) return removeIcon!;
    return Icon(
      Icons.backspace,
      color: decoration.itemColor,
      size: decoration.textStyle.fontSize,
    );
  }

  Widget _buildNumberKey(String number) => NumPadButton.text(
        number,
        height: decoration.buttonHeight,
        width: decoration.buttonWidth,
        textStyle: decoration.textStyle,
        shape: decoration.btnShape,
        onTap: () => onNumberKeyPressed(number),
      );
}
