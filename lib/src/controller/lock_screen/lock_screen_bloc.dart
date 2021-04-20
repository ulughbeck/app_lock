import 'package:flutter/foundation.dart';

import '../../biometrics/platform_biometrics.dart';
import '../../widgets/lock_screen/lock_screen.dart';
import '../bloc.dart';
import '../config.dart';

part 'lock_screen_event.dart';
part 'lock_screen_state.dart';

class LockScreenBloc extends Bloc<LockScreenEvent, LockScreenState> {
  final LockScreenPinValidator _validator;

  /// Creates [LockScreenBloc]
  LockScreenBloc(
    LockScreenConfig config, {
    required LockScreenPinValidator validator,
  }) : _validator = validator {
    add(LockScreenEvent._init(config));
  }

  @override
  void mapEventToState(LockScreenEvent event) => event.when(
        init: _init,
        inputPin: _inputPin,
        removePin: _removePin,
        resetInput: _resetInput,
        unlockWithBiometrics: _unlockWithBiometrics,
        unlockWithPin: _unlockWithPin,
      );

  Future<void> _init(LockScreenConfig config) async {
    // emit(LockScreenState(config: config));

    // get available biometrics
    final biometricsSupported = await PlatformBiometrics.avaiilableBiometric();
    var biometricsEnabled = config.isBiometricsEnabled;
    if (config.isBiometricsEnabled) {
      biometricsEnabled = biometricsSupported.isAvailable;
    }

    final biometricsAtStart = biometricsEnabled && config.askBiometricsAtStart;

    final configWithBiometrics = config.copyWith(
      biometricsSupportedType: biometricsSupported,
      isBiometricsEnabled: biometricsEnabled,
      askBiometricsAtStart: biometricsAtStart,
    );

    emit(LockScreenState(config: configWithBiometrics));
  }

  void _removePin() {
    if (currentState!.pinValue.isNotEmpty) {
      final newPinValue = currentState!.pinValue
          .substring(0, currentState!.pinValue.length - 1);
      return emit(currentState!.copyWith(pinValue: newPinValue));
    }
  }

  void _resetInput() {
    emit(currentState!.copyWith(pinValue: ''));
  }

  void _inputPin(String char) {
    final newPinValue = currentState!.pinValue + char;
    emit(currentState!.copyWith(pinValue: newPinValue));
  }

  Future<void> _unlockWithPin(String pinValue) async {
    final result = (await _validator(pinValue));

    if (result == null) {
      // send result of unlock attempt
      emit(currentState!.copyWith(isLockPassed: true, pinValue: ''));
    } else {
      emit(currentState!.copyWith(errorMessage: result, pinValue: ''));

      /// debounce time to show error message
      Future<void>.delayed(const Duration(milliseconds: 300), _resetInput);
    }
  }

  Future<void> _unlockWithBiometrics(String localizedReason) async {
    _resetInput();
    final result =
        await PlatformBiometrics.authkWithBiometrics(localizedReason);

    emit(currentState!.copyWith(isLockPassed: result));
  }
}
