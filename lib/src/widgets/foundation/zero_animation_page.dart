import 'package:flutter/widgets.dart';

class ZeroAnimationPage extends Page {
  final Widget child;

  const ZeroAnimationPage({required this.child});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
    );
  }
}
