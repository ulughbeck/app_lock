library portrait_orientation_mixin;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

///
mixin PortraitOrientationMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    // change orientation setttings
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // restore orientation settings
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}
