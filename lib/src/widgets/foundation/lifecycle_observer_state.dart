library statex;

import 'package:flutter/widgets.dart';

// ignore_for_file: prefer_mixin

/// State with Widget AppLifeCycleState callbacks
abstract class LifeCycleObserverState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => afterFirstBuild(context));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        return onAppResumed();
      case AppLifecycleState.inactive:
        return onAppInactivated();
      case AppLifecycleState.paused:
        return onAppPaused();
      case AppLifecycleState.detached:
        return onAppDetached();
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  /// Callback to be executed only once after initial build
  void afterFirstBuild(BuildContext context) {}

  /// Callback to be executed when app is resumed
  void onAppResumed() {}

  /// Callback to be executed when app is paused
  void onAppPaused() {}

  /// Callback to be executed when app is detached
  void onAppDetached() {}

  /// Callback to be executed when app is inactivated
  void onAppInactivated() {}

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
