part of 'lock_screen_bloc.dart';

@immutable
abstract class LockScreenEvent {
  const LockScreenEvent._();

  const factory LockScreenEvent._init(LockScreenConfig config) =
      _InitLockScreen;
  const factory LockScreenEvent.inputPin(String pin) = _InputLockPin;
  const factory LockScreenEvent.removePin() = _RemovePin;
  const factory LockScreenEvent.resetInput() = _ResetInput;
  const factory LockScreenEvent.unlockWithBiometrics(String localizedReason) =
      _UnlockWithBiometrics;
  const factory LockScreenEvent.unlockWithPin(String value) = _UnlockWithPin;

  void when({
    required void Function(LockScreenConfig config) init,
    required void Function(String pin) inputPin,
    required void Function() removePin,
    required void Function() resetInput,
    required void Function(String localizedReason) unlockWithBiometrics,
    required void Function(String value) unlockWithPin,
  }) {
    if (this is _InitLockScreen) {
      return init((this as _InitLockScreen).config);
    } else if (this is _InputLockPin) {
      return inputPin((this as _InputLockPin).char);
    } else if (this is _RemovePin) {
      return removePin();
    } else if (this is _ResetInput) {
      return resetInput();
    } else if (this is _UnlockWithBiometrics) {
      return unlockWithBiometrics(
        (this as _UnlockWithBiometrics).localizedReason,
      );
    } else if (this is _UnlockWithPin) {
      return unlockWithPin(
        (this as _UnlockWithPin).value,
      );
    }
  }
}

@immutable
class _InitLockScreen extends LockScreenEvent {
  final LockScreenConfig config;

  const _InitLockScreen(this.config) : super._();

  @override
  String toString() => '_InitLockScreen';
}

@immutable
class _InputLockPin extends LockScreenEvent {
  final String char;

  const _InputLockPin(this.char) : super._();

  @override
  String toString() => '_InputLockPin';
}

@immutable
class _RemovePin extends LockScreenEvent {
  const _RemovePin() : super._();

  @override
  String toString() => '_RemovePin';
}

@immutable
class _ResetInput extends LockScreenEvent {
  const _ResetInput() : super._();

  @override
  String toString() => '_ResetInput';
}

@immutable
class _UnlockWithBiometrics extends LockScreenEvent {
  final String localizedReason;

  const _UnlockWithBiometrics(this.localizedReason) : super._();

  @override
  String toString() => '_UnlockWithBiometrics';
}

@immutable
class _UnlockWithPin extends LockScreenEvent {
  final String value;

  const _UnlockWithPin(this.value) : super._();

  @override
  String toString() => '_UnlockWithPin';
}
