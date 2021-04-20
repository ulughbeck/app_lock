library vital_widget_app;

import 'dart:ui';

import 'package:flutter/widgets.dart';

// ignore_for_file: prefer_mixin

/// Bare Minimum [Widget] to be used as root widget for `runApp()` function
@immutable
class VitalWidgetApp extends StatelessWidget {
  /// [Widget] to be displayed
  final Widget home;

  /// creates [VitalWidgetApp]
  const VitalWidgetApp({
    Key? key,
    required this.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQueryData.fromWindow(window),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: home,
        ),
      );
}
