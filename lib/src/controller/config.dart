import 'dart:convert';

import '../biometrics/platform_biometrics.dart';

/// Lock Screen configurations
class LockScreenConfig {
  /// Number of PIN inputs default is 4
  final int pinLength;

  /// [true] if PIN is enabled, otherwise [false]
  final bool isPinEnabled;

  /// [true] if PIN is configured, otherwise [false]
  final bool isPinConfigured;

  /// [true] if Biometrics is enabled, otherwise [false]
  final bool isBiometricsEnabled;

  /// [true] if Biometrics should be asked at start, otherwise [false]
  final bool askBiometricsAtStart;

  /// if [true] App will be locked on being paused
  /// after `lockAfterDurationWhenPaused` passed
  final bool lockOnAppPaused;

  /// When App is paused after [Duration] passed
  final Duration lockOnPausedAfterDuration;

  /// Device Supported Biometricsw
  final PlatformBiometricsType biometricsSupportedType;

  /// [true] if Biometrics is supported on current device, otherwise [false]
  bool get isBiometricsSupported {
    if (biometricsSupportedType != PlatformBiometricsType.unknown &&
        biometricsSupportedType != PlatformBiometricsType.notAvailable) {
      return true;
    }
    return false;
  }

  /// Lock Screen Config
  const LockScreenConfig({
    required this.pinLength,
    this.isPinEnabled = false,
    this.isPinConfigured = false,
    this.isBiometricsEnabled = false,
    this.askBiometricsAtStart = false,
    this.lockOnAppPaused = true,
    this.lockOnPausedAfterDuration = const Duration(seconds: 3),
    this.biometricsSupportedType = PlatformBiometricsType.unknown,
  });

  LockScreenConfig copyWith({
    int? pinLength,
    bool? isPinEnabled,
    bool? isPinConfigured,
    bool? isBiometricsEnabled,
    bool? askBiometricsAtStart,
    bool? lockOnAppPaused,
    Duration? lockOnPausedAfterDuration,
    PlatformBiometricsType? biometricsSupportedType,
  }) {
    return LockScreenConfig(
      pinLength: pinLength ?? this.pinLength,
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      isPinConfigured: isPinConfigured ?? this.isPinConfigured,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      askBiometricsAtStart: askBiometricsAtStart ?? this.askBiometricsAtStart,
      lockOnAppPaused: lockOnAppPaused ?? this.lockOnAppPaused,
      lockOnPausedAfterDuration:
          lockOnPausedAfterDuration ?? this.lockOnPausedAfterDuration,
      biometricsSupportedType:
          biometricsSupportedType ?? this.biometricsSupportedType,
    );
  }

  Map<String, dynamic> _toMap() => {
        'pinLength': pinLength,
        'isPinEnabled': isPinEnabled,
        'isPinConfigured': isPinConfigured,
        'isBiometricsEnabled': isBiometricsEnabled,
        'askBiometricsAtStart': askBiometricsAtStart,
        'lockOnAppPaused': lockOnAppPaused,
        'lockOnPausedAfterDuration': lockOnPausedAfterDuration.inSeconds,
      };

  factory LockScreenConfig._fromMap(Map<String, dynamic> map) =>
      LockScreenConfig(
        pinLength: map['pinLength'] ?? 4,
        isPinEnabled: map['isPinEnabled'] ?? false,
        isPinConfigured: map['isPinConfigured'] ?? false,
        isBiometricsEnabled: map['isBiometricsEnabled'] ?? false,
        askBiometricsAtStart: map['askBiometricsAtStart'] ?? false,
        lockOnAppPaused: map['lockOnAppPaused'] ?? true,
        lockOnPausedAfterDuration: Duration(
          seconds: (map['lockOnPausedAfterDuration'] ?? 3),
        ),
      );

  String toJson() => json.encode(_toMap());

  factory LockScreenConfig.fromJson(String source) =>
      LockScreenConfig._fromMap(json.decode(source));
}
