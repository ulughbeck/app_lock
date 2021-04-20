part of 'app_locker_bloc.dart';

@immutable
abstract class AppLockerEvent {
  const AppLockerEvent._();

  const factory AppLockerEvent._init(LockScreenConfig config) = _InitAppLocker;
  const factory AppLockerEvent.reset(LockScreenConfig config) = _ResetAppLocker;
  const factory AppLockerEvent.savePin(String pin) = _SaveNewPin;
  const factory AppLockerEvent.enablePin() = _EnablePin;
  const factory AppLockerEvent.disablePin() = _DisablePin;
  const factory AppLockerEvent.enableBiometrics() = _EnableBiometrics;
  const factory AppLockerEvent.disableBiometrics() = _DisableBiometrics;

  void when({
    required void Function(LockScreenConfig config) init,
    required void Function(LockScreenConfig config) reset,
    required void Function(String pin) savePin,
    required void Function() enablePin,
    required void Function() disablePin,
    required void Function() enableBiometrics,
    required void Function() disableBiometrics,
  }) {
    if (this is _InitAppLocker) {
      return init((this as _InitAppLocker).config);
    } else if (this is _ResetAppLocker) {
      return reset((this as _ResetAppLocker).config);
    } else if (this is _SaveNewPin) {
      return savePin((this as _SaveNewPin).pin);
    } else if (this is _EnablePin) {
      return enablePin();
    } else if (this is _DisablePin) {
      return disablePin();
    } else if (this is _EnableBiometrics) {
      return enableBiometrics();
    } else if (this is _DisableBiometrics) {
      return disableBiometrics();
    }
  }
}

@immutable
class _InitAppLocker extends AppLockerEvent {
  final LockScreenConfig config;

  const _InitAppLocker(this.config) : super._();

  @override
  String toString() => '_InitAppLocker';
}

@immutable
class _ResetAppLocker extends AppLockerEvent {
  final LockScreenConfig config;

  const _ResetAppLocker(this.config) : super._();

  @override
  String toString() => '_ResetAppLocker';
}

@immutable
class _SaveNewPin extends AppLockerEvent {
  final String pin;

  const _SaveNewPin(this.pin) : super._();

  @override
  String toString() => '_SaveNewPin';
}

@immutable
class _EnablePin extends AppLockerEvent {
  const _EnablePin() : super._();

  @override
  String toString() => '_EnableAppLocker';
}

@immutable
class _DisablePin extends AppLockerEvent {
  const _DisablePin() : super._();

  @override
  String toString() => '_DisableAppLocker';
}

@immutable
class _EnableBiometrics extends AppLockerEvent {
  const _EnableBiometrics() : super._();

  @override
  String toString() => '_EnableBiometrics';
}

@immutable
class _DisableBiometrics extends AppLockerEvent {
  const _DisableBiometrics() : super._();

  @override
  String toString() => '_DisableBiometrics';
}
