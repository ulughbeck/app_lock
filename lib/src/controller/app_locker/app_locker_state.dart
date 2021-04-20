part of 'app_locker_bloc.dart';

@immutable
class AppLockerState {
  final bool loading;

  /// Current Lock Screen config
  final LockScreenConfig config;

  /// reutrns correct PIN code
  final String? correctPin;

  /// App Locker State
  AppLockerState({
    required this.loading,
    required this.config,
    this.correctPin,
  });

  /// constructor to copy with values
  AppLockerState copyWith({
    bool? loading,
    LockScreenConfig? config,
    String? correctPin,
  }) {
    return AppLockerState(
      loading: loading ?? this.loading,
      config: config ?? this.config,
      correctPin: correctPin ?? this.correctPin,
    );
  }
}
