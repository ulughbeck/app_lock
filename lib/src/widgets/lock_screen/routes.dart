part of 'lock_screen.dart';

/// [LockScreen] [ModalRoute] name
const String lockScreenRoute = 'lock';

/// [LockScreen] Route extensions
extension LockScreenRoutes on LockScreen {
  /// set new pin code
  static Route<bool> enterPin({
    required String correctPin,
    required VoidCallback onUnlock,
    required String title,
    required String errorMessage,
    required String biometricsTitle,
    RouteTransitionsBuilder transitionsBuilder =
        LockScreenTransitinos.noTransition,
    LockScreenDecoration decoration = const LockScreenDecoration(),
    WillPopCallback? onWillPop,
    bool? enableBiometrics,
    bool? askBiometricsAtStart,
    Widget? top,
    Widget? bottom,
    Widget? removeIcon,
    Widget? biometricsIcon,
  }) =>
      PageRouteBuilder(
        settings: _settings,
        transitionsBuilder: transitionsBuilder,
        pageBuilder: (context, primaryAnimation, secondaryAnimation) =>
            LockScreen(
          onWillPop: onWillPop,
          pinLength: correctPin.length,
          decoration: decoration,
          title: title,
          biometricsTitle: biometricsTitle,
          askBiometricsAtStart: askBiometricsAtStart ?? false,
          enableBiometrics: enableBiometrics ?? false,
          validator: (value) async {
            if (correctPin != value) return errorMessage;
            return null;
          },
          onUnlock: onUnlock,
          top: top,
          bottom: bottom,
          removeIcon: removeIcon,
          biometricsIcon: biometricsIcon,
        ),
      );

  /// set new pin code
  static Route<void> setNewPin({
    required Function(String) savePin,
    required Function onPinSetFinish,
    required String setPinTitle,
    required String repeatPinTitle,
    required String dontMatchErrorMessage,
    int pinLength = 4,
    RouteTransitionsBuilder transitionsBuilder =
        LockScreenTransitinos.noTransition,
    LockScreenDecoration decoration = const LockScreenDecoration(),
    WillPopCallback? onWillPop,
    Widget? top,
    Widget? bottom,
    Widget? removeIcon,
  }) {
    // ignore: omit_local_variable_types
    String newPinCode = '';

    return PageRouteBuilder(
      settings: _settings,
      transitionsBuilder: transitionsBuilder,
      pageBuilder: (context, primaryAnimation, secondaryAnimation) =>
          LockScreen(
        onWillPop: onWillPop,
        pinLength: pinLength,
        decoration: decoration,
        title: setPinTitle,
        biometricsTitle: '',
        enableBiometrics: false,
        top: top,
        bottom: bottom,
        removeIcon: removeIcon,
        onPinInputFinished: (value) => newPinCode = value,
        validator: (value) async => null,
        onUnlock: () => Navigator.of(context, rootNavigator: true).push<void>(
          PageRouteBuilder(
            settings: _settings,
            pageBuilder: (context, primaryAnimation, secondaryAnimation) =>
                LockScreen(
              pinLength: pinLength,
              decoration: decoration,
              title: repeatPinTitle,
              biometricsTitle: '',
              enableBiometrics: false,
              top: top,
              bottom: bottom,
              removeIcon: removeIcon,
              validator: (value) async {
                if (newPinCode != value) return dontMatchErrorMessage;
                return null;
              },
              onPinInputFinished: (value) {
                if (newPinCode == value) savePin(newPinCode);
              },
              onUnlock: () {
                onPinSetFinish();
                Navigator.of(context, rootNavigator: true).popUntil(
                  (route) => route.settings.name != lockScreenRoute,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// change pin code
  static Route<void> changePin({
    required String currentPin,
    required Function(String) saveNewPin,
    required Function onPinSetFinish,
    required String enterPinTitle,
    required String errorPinTitle,
    required String setPinTitle,
    required String repeatPinTitle,
    required String dontMatchErrorMessage,
    required String currentPinError,
    RouteTransitionsBuilder transitionsBuilder =
        LockScreenTransitinos.noTransition,
    LockScreenDecoration decoration = const LockScreenDecoration(),
    WillPopCallback? onWillPop,
    Widget? top,
    Widget? bottom,
    Widget? removeIcon,
  }) =>
      PageRouteBuilder(
        settings: _settings,
        transitionsBuilder: transitionsBuilder,
        pageBuilder: (context, primaryAnimation, secondaryAnimation) =>
            LockScreen(
          onWillPop: onWillPop,
          pinLength: currentPin.length,
          decoration: decoration,
          title: enterPinTitle,
          biometricsTitle: '',
          enableBiometrics: false,
          top: top,
          bottom: bottom,
          removeIcon: removeIcon,
          validator: (value) async {
            if (value != currentPin) return errorPinTitle;
            return null;
          },
          onUnlock: () => Navigator.of(context, rootNavigator: true).push<void>(
            LockScreenRoutes.setNewPin(
              pinLength: currentPin.length,
              decoration: decoration,
              setPinTitle: setPinTitle,
              repeatPinTitle: repeatPinTitle,
              dontMatchErrorMessage: dontMatchErrorMessage,
              savePin: saveNewPin,
              onPinSetFinish: onPinSetFinish,
              top: top,
              bottom: bottom,
              removeIcon: removeIcon,
            ),
          ),
        ),
      );

  /// [RouteSettings] with name configured
  static const RouteSettings _settings = RouteSettings(name: lockScreenRoute);
}
