import 'package:flutter/material.dart';

import '../app_locker/app_locker.dart';

/// Switch to enable or disable biometrics for Lock Screen
class BiometricsSwitch extends StatefulWidget {
  /// Biometrics description
  final String biometricsText;

  /// constructor
  const BiometricsSwitch({
    Key? key,
    this.biometricsText = 'Use Biometrics on Lock Screen',
  }) : super(key: key);

  @override
  _BiometricsSwitchState createState() => _BiometricsSwitchState();
}

class _BiometricsSwitchState extends State<BiometricsSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.biometricsText),
        Switch.adaptive(
          value: AppLocker.of(context).isBiometricsEnabled,
          onChanged: (value) {
            value
                ? AppLocker.of(context).enableBiometrics()
                : AppLocker.of(context).disableBiometrics();
            setState(() {});
          },
        ),
      ],
    );
  }
}
