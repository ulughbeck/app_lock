import 'package:flutter/material.dart';

import '../app_locker/app_locker.dart';

/// App Locker Switch to enable and disable App Locker
class AppLockerSwitch extends StatefulWidget {
  /// App Locker description
  final String appLockerText;

  /// constructor
  const AppLockerSwitch({
    this.appLockerText = 'Enable PIN Lock Screen',
    Key? key,
  }) : super(key: key);

  @override
  _AppLockerSwitchState createState() => _AppLockerSwitchState();
}

class _AppLockerSwitchState extends State<AppLockerSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.appLockerText),
        Switch.adaptive(
          value: AppLocker.of(context).isPinEnabled,
          onChanged: (value) async {
            if (AppLocker.of(context).isPinConfigured) {
              value
                  ? AppLocker.of(context).enablePin()
                  : AppLocker.of(context).disablePin();
            } else {
              await AppLocker.of(context).setNewPin();
            }
            setState(() {});
          },
        ),
      ],
    );
  }
}
