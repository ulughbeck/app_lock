import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../biometrics/platform_biometrics.dart';
import '../bloc.dart';
import '../config.dart';

part 'app_locker_event.dart';
part 'app_locker_state.dart';

const lockerPin = 'APP_LOCKER_PIN';
const lockerCnfig = 'APP_LOCKER_CONFIG';

/// App Locker Bloc
class AppLockerBloc extends Bloc<AppLockerEvent, AppLockerState> {
  late SharedPreferences _prefs;

  /// constructor can be provided with initial Lock Screen configurations
  AppLockerBloc(LockScreenConfig config) {
    add(AppLockerEvent._init(config));
  }

  @override
  void mapEventToState(AppLockerEvent event) => event.when(
        init: _init,
        reset: _reset,
        savePin: _saveNewPin,
        enablePin: _enablePin,
        disablePin: _disablePin,
        enableBiometrics: _enableBiometrics,
        disableBiometrics: _disableBiometrics,
      );

  /// Init App Locker from saved and/or provided config
  Future<void> _init(LockScreenConfig config) async {
    emit(AppLockerState(
      loading: true,
      config: config,
    ));

    final configWithBio = await _generateConfingWithBiometrics(config);

    _prefs = await SharedPreferences.getInstance();
    final correctPin = _prefs.getString(lockerPin);

    /// PIN was not set yet
    if (correctPin == null) {
      return emit(AppLockerState(
        loading: false,
        config: configWithBio,
        correctPin: correctPin,
      ));
    }

    /// If PIN length changed
    if (correctPin.length != config.pinLength) {
      return emit(AppLockerState(
        loading: false,
        config: configWithBio,
        correctPin: correctPin,
      ));
    }

    final raw = _prefs.getString(lockerCnfig);
    final savedConfig =
        raw != null ? LockScreenConfig.fromJson(raw) : configWithBio;

    return emit(AppLockerState(
      loading: false,
      config: savedConfig,
      correctPin: correctPin,
    ));
  }

  Future<LockScreenConfig> _generateConfingWithBiometrics(
    LockScreenConfig config,
  ) async {
    // get available biometrics
    final biometricsSupported = await PlatformBiometrics.avaiilableBiometric();
    var biometricsEnabled = config.isBiometricsEnabled;
    if (config.isBiometricsEnabled) {
      biometricsEnabled =
          biometricsSupported != PlatformBiometricsType.notAvailable &&
              biometricsSupported != PlatformBiometricsType.unknown;
    }
    final biometricsAtStart = config.askBiometricsAtStart && biometricsEnabled;

    return LockScreenConfig(
      isPinEnabled: false,
      isPinConfigured: false,
      pinLength: config.pinLength,
      isBiometricsEnabled: biometricsEnabled,
      askBiometricsAtStart: biometricsAtStart,
    );
  }

  /// Reset App Locker to default values
  /// Remove all configs and set PIN
  Future<void> _reset(LockScreenConfig config) async {
    _prefs.remove(lockerPin);
    _prefs.remove(lockerCnfig);
    return emit(AppLockerState(
      loading: false,
      config: config,
    ));
  }

  /// saves new PIN code provided
  Future<void> _saveNewPin(String newPin) async {
    emit(currentState!.copyWith(
      correctPin: newPin,
      config: currentState!.config.copyWith(
        isPinEnabled: true,
        isPinConfigured: true,
      ),
    ));
    _prefs.setString(lockerPin, newPin);
  }

  /// enable PIN lock
  void _enablePin() => _changeAppLockerConfig(
        currentState!.config.copyWith(isPinEnabled: true),
      );

  /// disable PIN lock
  void _disablePin() => _changeAppLockerConfig(
        currentState!.config.copyWith(isPinEnabled: false),
      );

  /// enable Biometrics on lock screen
  void _enableBiometrics() => _changeAppLockerConfig(
        currentState!.config.copyWith(isBiometricsEnabled: true),
      );

  /// disable Biometrics on lock screen
  void _disableBiometrics() => _changeAppLockerConfig(
        currentState!.config.copyWith(isBiometricsEnabled: false),
      );

  void _changeAppLockerConfig(LockScreenConfig config) {
    emit(currentState!.copyWith(config: config));
    _prefs.setString(lockerCnfig, currentState!.config.toJson());
  }
}
