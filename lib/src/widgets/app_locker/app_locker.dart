import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../biometrics/platform_biometrics.dart';
import '../../controller/controller.dart';
import '../../theme/decoration.dart';
import '../foundation/foundation.dart';
import '../lock_screen/lock_screen.dart';
import '../settings/setup_biometrics_page.dart';

/// App Locker Scope. Wrap your widget tree with this widget to enable locker
class AppLocker extends StatefulWidget {
  /// App widget
  final Widget child;

  /// Widget to be shown while loading state of Lock Screen
  final Widget placeholder;

  /// Number of PIN inputs default is 4
  final int pinLength;

  /// [true] if App should be locked when paused, otherwise [false]
  final bool lockOnAppPaused;

  /// timeout after which app will be locked when it is paused
  final Duration lockOnPausedAfter;

  /// [true] if Biometrics should be enabled, otherwise [false]
  final bool enableBiometrics;

  /// [true] if Biometrics should be asked at start, otherwise [false]
  final bool askBiometricsAtStart;

  /// Ttitle to show when Biometrics asked
  final String biometricsTitle;

  /// Title of Lock Screen
  final String title;

  /// Set new PIN title
  final String setPinTitle;

  /// Repeat new PIN title
  final String repeatPinTitle;

  /// Error message to be shown for incorrect PIN
  final String errorMessage;

  /// Confirm PIN doen't match error title
  final String dontMatchErrorMessage;

  /// Lock Screen Decoration
  final LockScreenDecoration decoration;

  /// Widget to be shown at the very top of Lock Screen
  final Widget? top;

  /// Widget to be shown at the very bottom of Lock Screen
  final Widget? bottom;

  /// condition to lock the app on start when [true]
  final InitialLockCondition? lockOnStartWhen;

  /// Constructor
  const AppLocker({
    required this.child,
    this.pinLength = 4,
    this.lockOnAppPaused = true,
    this.lockOnPausedAfter = const Duration(seconds: 3),
    this.enableBiometrics = false,
    this.askBiometricsAtStart = false,
    this.title = 'Enter PIN',
    this.biometricsTitle = 'Use Biometrics to unlock',
    this.errorMessage = 'Wrong PIN',
    this.setPinTitle = 'Set new PIN',
    this.repeatPinTitle = 'Repeat PIN',
    this.dontMatchErrorMessage = "PINs don't match",
    this.decoration = const LockScreenDecoration(),
    this.placeholder = const SizedBox.shrink(),
    this.lockOnStartWhen,
    this.top,
    this.bottom,
    Key? key,
  }) : super(key: key);

  @override
  _AppLockerState createState() => _AppLockerState();

  /// returns the closest [AppLocker] from widget tree
  static _AppLockerState of(BuildContext context) =>
      context.findAncestorStateOfType<_AppLockerState>()!;
}

class _AppLockerState extends LifeCycleObserverState<AppLocker> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  late AppLockerBloc _bloc;
  late StreamSubscription<AppLockerState> _sub;
  late bool _isAppLocked;
  late bool _isAppLockerInitialised;
  late bool _isAppLockerScreenActive;

  @override
  void initState() {
    super.initState();
    _isAppLockerInitialised = false;
    _isAppLockerScreenActive = false;
    _isAppLocked = false;

    _bloc = AppLockerBloc(
      LockScreenConfig(
        isPinEnabled: true,
        isPinConfigured: true,
        pinLength: widget.pinLength,
        isBiometricsEnabled: widget.enableBiometrics,
        askBiometricsAtStart: widget.askBiometricsAtStart,
        lockOnAppPaused: widget.lockOnAppPaused,
        lockOnPausedAfterDuration: widget.lockOnPausedAfter,
      ),
    );

    _sub = _bloc.state.listen((state) async {
      if (state.loading == false) {
        _sub.cancel();
        if (await widget.lockOnStartWhen?.call() ?? true) {
          lockApp();
        }
        setState(() => _isAppLockerInitialised = true);
      }
    });
  }

  DateTime? _lastActiveTimestamp;

  @override
  void onAppResumed() {
    if (_shouldLockWhenResumed) lockApp();
    // cleat last active timestamp
    _lastActiveTimestamp = null;
  }

  @override
  void onAppPaused() {
    // save last active time
    _lastActiveTimestamp = DateTime.now();
  }

  @override
  Future<bool> didPopRoute() async {
    print(_isAppLockerScreenActive);

    if (_isAppLockerScreenActive) {
      _navKey.currentState?.maybePop();
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    _bloc.dispose();
    super.dispose();
  }

  /// lock App
  void lockApp() {
    if (isPinEnabled) {
      _isAppLocked = true;
      _pushLockScreen();
    }
  }

  /// unlock App
  void unlockApp() {
    _isAppLocked = false;
    _isAppLockerScreenActive = false;
    _navKey.currentState?.popUntil(
      (route) => route.settings.name != lockScreenRoute,
    );
  }

  /// returns [true] if app should be lockedm otherwise [false]
  bool get _shouldLockWhenResumed {
    if (_isAppLocked) return false;
    if (_lastActiveTimestamp == null) return false;
    return DateTime.now().difference(_lastActiveTimestamp!) >
        widget.lockOnPausedAfter;
  }

  /// Current state LockScreenConfig
  LockScreenConfig get _config => _bloc.currentState!.config;

  /// Correct Pin value
  String get _correctPin => _bloc.currentState!.correctPin!;

  /// returns [true] if PIN Lock Screen was configured, otherwise [false]
  bool get isPinConfigured => _config.isPinConfigured;

  /// returns [true] if PIN Lock Screen is enabled, otherwise [false]
  bool get isPinEnabled => _config.isPinEnabled;

  /// returns [true] if Biometrics is enabled for Lock Screen, otherwise [false]
  bool get isBiometricsEnabled => _config.isBiometricsEnabled;

  /// enable PIN Lock Screen
  void enablePin() {
    if (isPinConfigured) _bloc.add(const AppLockerEvent.enablePin());
  }

  /// disable PIN Lock Screen
  void disablePin() => _bloc.add(const AppLockerEvent.disablePin());

  /// enable Biometrics for Lock Screen
  void enableBiometrics() => _bloc.add(const AppLockerEvent.enableBiometrics());

  /// disable Biometrics for Lock Screen
  void disableBiometrics() =>
      _bloc.add(const AppLockerEvent.disableBiometrics());

  /// resets App Locker
  void resetAppLocker() {
    _bloc.add(AppLockerEvent.reset(
      LockScreenConfig(
        pinLength: widget.pinLength,
        isPinEnabled: false,
        isPinConfigured: false,
        isBiometricsEnabled: false,
        askBiometricsAtStart: widget.askBiometricsAtStart,
      ),
    ));

    // remove Lock Screen if showing
    unlockApp();
  }

  /// start setup of App Locker process
  void setup() {
    _isAppLockerScreenActive = true;
    _navKey.currentState?.push(
      LockScreenRoutes.setNewPin(
        pinLength: _config.pinLength,
        setPinTitle: widget.setPinTitle,
        repeatPinTitle: widget.repeatPinTitle,
        dontMatchErrorMessage: widget.dontMatchErrorMessage,
        decoration: widget.decoration,
        top: widget.top,
        bottom: widget.bottom,
        savePin: (value) async => _bloc.add(AppLockerEvent.savePin(value)),
        onPinSetFinish: () {
          _isAppLockerScreenActive = false;
          _bloc.add(const AppLockerEvent.enableBiometrics());
          _setupBiometrics();
        },
        onWillPop: () async {
          _isAppLockerScreenActive = false;
          return true;
        },
      ),
    );
  }

  /// start set new PIN process
  Future<void>? setNewPin() {
    _isAppLockerScreenActive = true;
    _navKey.currentState?.push<void>(
      LockScreenRoutes.setNewPin(
        pinLength: _config.pinLength,
        setPinTitle: widget.setPinTitle,
        repeatPinTitle: widget.repeatPinTitle,
        dontMatchErrorMessage: widget.dontMatchErrorMessage,
        decoration: widget.decoration,
        top: widget.top,
        bottom: widget.bottom,
        savePin: (value) async => _bloc.add(AppLockerEvent.savePin(value)),
        onPinSetFinish: () {
          _isAppLockerScreenActive = false;
          _bloc.add(const AppLockerEvent.enablePin());
        },
        onWillPop: () async {
          _isAppLockerScreenActive = false;
          return true;
        },
      ),
    );
  }

  /// start change current PIN process
  Future<void>? changePinCode() {
    _isAppLockerScreenActive = true;
    if (isPinConfigured) {
      return _navKey.currentState?.push(
        LockScreenRoutes.changePin(
          currentPin: _correctPin,
          enterPinTitle: widget.title,
          errorPinTitle: widget.errorMessage,
          setPinTitle: widget.setPinTitle,
          currentPinError: widget.errorMessage,
          repeatPinTitle: widget.repeatPinTitle,
          dontMatchErrorMessage: widget.dontMatchErrorMessage,
          decoration: widget.decoration,
          top: widget.top,
          bottom: widget.bottom,
          saveNewPin: (value) async => _bloc.add(AppLockerEvent.savePin(value)),
          onPinSetFinish: () {
            _isAppLockerScreenActive = false;
          },
          onWillPop: () async {
            _isAppLockerScreenActive = false;
            return true;
          },
        ),
      );
    }
    return setNewPin();
  }

  void _pushLockScreen() {
    _isAppLockerScreenActive = true;
    _navKey.currentState?.push(
      LockScreenRoutes.enterPin(
        correctPin: _correctPin,
        onUnlock: unlockApp,
        onWillPop: _onLockScreenPop,
        askBiometricsAtStart: _config.askBiometricsAtStart,
        enableBiometrics: _config.isBiometricsEnabled,
        title: widget.title,
        errorMessage: widget.errorMessage,
        biometricsTitle: widget.biometricsTitle,
        decoration: widget.decoration,
        top: widget.top,
        bottom: widget.bottom,
      ),
    );
  }

  Future<void> _setupBiometrics() async {
    if (widget.enableBiometrics) {
      final biometricsSupported =
          await PlatformBiometrics.isBiometricsSupported();

      if (biometricsSupported) {
        final result = await _navKey.currentState?.push<bool>(
          PageRouteBuilder(
            pageBuilder: (context, _, __) => SetupBiometricsPage(
              backgroundColor: widget.decoration.backgroundColor,
              primaryColor: widget.decoration.pinFieldDecoration.fillColor,
              biometricsTitle: widget.biometricsTitle,
              onWillPop: () async {
                Navigator.of(context).pop(false);
                return false;
              },
            ),
          ),
        );

        if (result == null) return disableBiometrics();
        return result ? enableBiometrics() : disableBiometrics();
      }
    }
  }

  Future<bool> _onLockScreenPop() async {
    SystemChannels.platform.invokeMethod<bool>('SystemNavigator.pop');
    return false;
  }

  @override
  Widget build(BuildContext context) => VitalWidgetApp(
        home: Navigator(
          key: _navKey,
          onPopPage: (route, result) => false,
          pages: [
            ZeroAnimationPage(child: widget.placeholder),
            if (_isAppLockerInitialised) ZeroAnimationPage(child: widget.child),
            if (_isAppLocked)
              ZeroAnimationPage(
                child: LockScreen(
                  pinLength: _correctPin.length,
                  onWillPop: _onLockScreenPop,
                  askBiometricsAtStart: _config.askBiometricsAtStart,
                  enableBiometrics: _config.isBiometricsEnabled,
                  validator: (value) async {
                    if (_bloc.currentState!.correctPin != value) {
                      return widget.errorMessage;
                    }
                    return null;
                  },
                  onUnlock: () {
                    _isAppLockerScreenActive = false;
                    _isAppLocked = false;
                    setState(() {});
                  },
                  title: widget.title,
                  biometricsTitle: widget.biometricsTitle,
                  decoration: widget.decoration,
                  top: widget.top,
                  bottom: widget.bottom,
                ),
              ),
          ],
        ),
      );
}

///
typedef InitialLockCondition = Future<bool> Function();
