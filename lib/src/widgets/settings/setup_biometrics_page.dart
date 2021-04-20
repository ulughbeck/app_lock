import 'package:flutter/material.dart';

/// Default Setup of Biometrics for Lock Screen
/// returns [true] if Biometrics should be enabled
/// otherwise [false]
@immutable
class SetupBiometricsPage extends StatelessWidget {
  /// Scaffold background color
  final Color backgroundColor;
  final Color primaryColor;
  final String biometricsTitle;
  final WillPopCallback? onWillPop;

  /// Initial Setup of Biometrics for Lock Screen
  const SetupBiometricsPage({
    Key? key,
    required this.backgroundColor,
    required this.primaryColor,
    required this.biometricsTitle,
    this.onWillPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (onWillPop != null) return onWillPop!.call();
          return false;
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              children: [
                const Spacer(),
                const Icon(
                  Icons.fingerprint_outlined,
                  size: 88,
                ),
                const SizedBox(height: 20),
                Text(
                  biometricsTitle,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );
}
