import 'package:flutter/material.dart';

import 'theme/decoration.dart';
import 'widgets/foundation/foundation.dart';
import 'widgets/lock_screen/lock_screen.dart';
import 'widgets/settings/app_locker_switch.dart';
import 'widgets/settings/biometrics_switch.dart';

/// displays [LockScreen] and gives user a single chance to enter PIN
///
/// returns [true] if user entered correct `pinCode`
/// returns [false] if user closes [LockScreen]
Future<bool?> showLockScreen(
  BuildContext context, {
  required String correctPin,
  LockScreenDecoration decoration = const LockScreenDecoration(),
  RouteTransitionsBuilder transitionsBuilder =
      LockScreenTransitinos.slideFromBottomTransition,
  String title = 'Enter PIN',
  String errorMessage = 'Wrong PIN',
  String biometricsTitle = '',
  bool enableBiometrics = false,
  bool askBiometricsAtStart = false,
  Widget? top,
  Widget? bottom,
  Widget? removeIcon,
  Widget? biometricsIcon,
}) {
  return Navigator.of(context, rootNavigator: true).push<bool>(
    LockScreenRoutes.enterPin(
      correctPin: correctPin,
      onUnlock: () => Navigator.of(context, rootNavigator: true).pop(true),
      onWillPop: () {
        Navigator.of(context, rootNavigator: true).pop(false);
        return Future.value(false);
      },
      decoration: decoration,
      transitionsBuilder: transitionsBuilder,
      title: title,
      errorMessage: errorMessage,
      biometricsTitle: biometricsTitle,
      enableBiometrics: enableBiometrics,
      askBiometricsAtStart: askBiometricsAtStart,
      top: top,
      bottom: bottom,
      removeIcon: removeIcon,
      biometricsIcon: biometricsIcon,
    ),
  );
}

/// displays [LockScreen] and pushes provided [Route] if user enters
/// `correctPin` provided
// ignore: missing_return
Future<T?> unlockAndPush<T>(
  BuildContext context,
  Route<T?> route, {
  required String correctPin,
  LockScreenDecoration decoration = const LockScreenDecoration(),
  RouteTransitionsBuilder transitionsBuilder =
      LockScreenTransitinos.noTransition,
  String title = 'Enter PIN',
  String errorMessage = 'Wrong PIN',
  String biometricsTitle = '',
  bool enableBiometrics = false,
  bool askBiometricsAtStart = false,
  Widget? top,
  Widget? bottom,
  Widget? removeIcon,
  Widget? biometricsIcon,
}) async {
  final result = await showLockScreen(
    context,
    correctPin: correctPin,
    decoration: decoration,
    transitionsBuilder: transitionsBuilder,
    title: title,
    errorMessage: errorMessage,
    biometricsTitle: biometricsTitle,
    enableBiometrics: enableBiometrics,
    askBiometricsAtStart: askBiometricsAtStart,
    top: top,
    bottom: bottom,
    removeIcon: removeIcon,
    biometricsIcon: biometricsIcon,
  );
  if (result != null) {
    if (result) return Navigator.of(context).push<T?>(route);
  }
}

/// displays [LockScreen] and pushes provided `routeName` if user enters
/// `correctPin` provided
// ignore: missing_return
Future<T?> unlockAndPushNamed<T>(
  BuildContext context,
  String routeName, {
  required String correctPin,
  LockScreenDecoration decoration = const LockScreenDecoration(),
  RouteTransitionsBuilder transitionsBuilder =
      LockScreenTransitinos.noTransition,
  String title = 'Enter PIN',
  String errorMessage = 'Wrong PIN',
  String biometricsTitle = '',
  bool enableBiometrics = false,
  bool askBiometricsAtStart = false,
  Widget? top,
  Widget? bottom,
  Widget? removeIcon,
  Widget? biometricsIcon,
}) async {
  final result = await showLockScreen(
    context,
    correctPin: correctPin,
    decoration: decoration,
    transitionsBuilder: transitionsBuilder,
    title: title,
    errorMessage: errorMessage,
    biometricsTitle: biometricsTitle,
    enableBiometrics: enableBiometrics,
    askBiometricsAtStart: askBiometricsAtStart,
    top: top,
    bottom: bottom,
    removeIcon: removeIcon,
    biometricsIcon: biometricsIcon,
  );
  if (result != null) {
    if (result) return Navigator.of(context).pushNamed<T>(routeName);
  }
}

/// Shows BottomSheet with App Locker settings
void showAppLockerSettings(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (cmontext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AppLockerSwitch(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: BiometricsSwitch(),
        ),
        SizedBox(height: 50),
      ],
    ),
  );
}
