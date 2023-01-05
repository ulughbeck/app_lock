library platform_biometrics;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// ignore_for_file: avoid_print
// ignore_for_file: avoid_classes_with_only_static_members

/// Wrapper for Local Authentication
abstract class PlatformBiometrics {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Returns [PlatformBiometricsType] of supported biometrics
  /// if nothing supported returns [PlatformBiometricsType.notAvailable]
  static Future<PlatformBiometricsType> avaiilableBiometric() async {
    if (kIsWeb) return PlatformBiometricsType.notAvailable;
    final canCheckBiometrcis = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrcis) return PlatformBiometricsType.notAvailable;

    final availableBiometrics = await _localAuth.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) return PlatformBiometricsType.notAvailable;

    final firstAvailable = availableBiometrics.first;
    switch (firstAvailable) {
      case BiometricType.face:
        return PlatformBiometricsType.face;
      case BiometricType.fingerprint:
        return PlatformBiometricsType.fingerprint;
      case BiometricType.iris:
        return PlatformBiometricsType.iris;
      default:
        return PlatformBiometricsType.unknown;
    }
  }

  static Future<bool> isBiometricsSupported() async {
    if (kIsWeb) return false;
    final biometricsSupported = await avaiilableBiometric();
    if (biometricsSupported != PlatformBiometricsType.unknown &&
        biometricsSupported != PlatformBiometricsType.notAvailable) {
      return true;
    }
    return false;
  }

  /// Returns [true] if the user successfully authenticates with buometrics,
  /// otherwise [false]
  static Future<bool> authkWithBiometrics(String localizedReason) async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  /// Cancel authentication
  static void cancelAuthentication() => _localAuth.stopAuthentication();
}

/// Possible Biometrics Types
enum PlatformBiometricsType {
  /// Face ID
  face,

  /// Fingerprint
  fingerprint,

  /// Iris
  iris,

  /// Unknwon biometrics
  unknown,

  /// Biometrics not available
  notAvailable,
}

extension PlatformBiometricsTypeX on PlatformBiometricsType {
  /// returns [true] if Biometrics is available for current device,
  /// otherwise [false]
  bool get isAvailable {
    return this != PlatformBiometricsType.notAvailable &&
        this != PlatformBiometricsType.unknown;
  }
}
