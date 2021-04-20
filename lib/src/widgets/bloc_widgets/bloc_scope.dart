import 'package:flutter/widgets.dart';

import '../../controller/controller.dart';

/// Lock Screen Bloc inherited scope
@immutable
class LockScreenBlocScope extends InheritedWidget {
  /// Lock Screen Bloc
  final LockScreenBloc bloc;

  /// constructor
  const LockScreenBlocScope({
    required Widget child,
    required this.bloc,
    Key? key,
  }) : super(key: key, child: child);

  /// For context lookup of LockScreenBloc bloc
  static LockScreenBloc? of(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<LockScreenBlocScope>()
          ?.bloc;
    } else {
      final inheritedWidget = context
          .getElementForInheritedWidgetOfExactType<LockScreenBlocScope>()
          ?.widget;
      return inheritedWidget is LockScreenBlocScope
          ? inheritedWidget.bloc
          : null;
    }
  }

  @override
  bool updateShouldNotify(LockScreenBlocScope oldWidget) =>
      bloc != oldWidget.bloc;
}

extension LockScreenBlocX on BuildContext {
  LockScreenBloc bloc() => LockScreenBlocScope.of(this)!;
}
