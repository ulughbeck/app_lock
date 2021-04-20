part of 'lock_screen_bloc.dart';

@immutable
class LockScreenState {
  final LockScreenConfig config;
  final String pinValue;
  final String errorMessage;
  final bool isLockPassed;

  bool get askBiometricsAtStart {
    if (config.biometricsSupportedType.isAvailable) {
      return config.askBiometricsAtStart;
    }
    return false;
  }

  bool get isPinInputFinished => config.pinLength == pinValue.length;

  bool get isBadAttempt => errorMessage.isNotEmpty;

  bool get isUnlocked => (isLockPassed && errorMessage.isEmpty);

  LockScreenState({
    required this.config,
    this.pinValue = '',
    this.errorMessage = '',
    this.isLockPassed = false,
  });

  LockScreenState copyWith({
    LockScreenConfig? config,
    String? pinValue,
    String? errorMessage,
    bool? isLockPassed,
  }) {
    return LockScreenState(
      config: config ?? this.config,
      pinValue: pinValue ?? this.pinValue,
      errorMessage: errorMessage ?? '',
      isLockPassed: isLockPassed ?? this.isLockPassed,
    );
  }
}
