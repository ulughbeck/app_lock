import 'package:flutter/material.dart';

import '../../controller/controller.dart';
import '../../theme/decoration.dart';
import '../bloc_widgets/bloc_consumer.dart';
import '../bloc_widgets/bloc_scope.dart';
import '../foundation/foundation.dart';
import 'numpad/numpad.dart';
import 'pin_area/error_message.dart';
import 'pin_area/pin_area.dart';

part 'routes.dart';

/// Lock Screen
class LockScreen extends StatefulWidget {
  /// Number of Pin Fields
  ///
  /// Default is 4
  final int pinLength;

  /// Callback to validate Pin Code attempt
  ///
  /// If the callback returns a [Future] that resolves to [true],
  /// Pin Code is valid and `onUnlock` callback will be called,
  /// otherwise `errorMessage` will be shown
  final LockScreenPinValidator validator;

  /// Called when user finishes Pin Code input
  ///
  /// Takes in [String] which is a Pin Code value attempt entered by user
  final ValueChanged<String>? onPinInputFinished;

  /// Called when user inputted correct Pin Code value.
  ///
  /// Typically should be used to pop [LockScreen] or move to other [ModalRoute]
  final VoidCallback onUnlock;

  /// Called to veto attempts by the user to dismiss the enclosing [LockScreen].
  ///
  /// Simmilar to [Scaffold.onWillPop]
  final WillPopCallback? onWillPop;

  /// Lock Screen Decoration
  final LockScreenDecoration decoration;

  /// [true] if Biometrics should be enabled, otherwise [false]
  final bool enableBiometrics;

  /// [true] if Biometrics should be asked at start, otherwise [false]
  final bool askBiometricsAtStart;

  /// title of [LockeScreen]
  final String title;

  /// Ttitle to show when Biometrics asked
  final String biometricsTitle;

  /// [Widget] to be shown at the very top of [LockScreen]
  final Widget? top;

  /// [Widget] to be shown at the very bottom of [LockScreen]
  final Widget? bottom;

  /// Widget to be shown on Biometrics Button
  final Widget? biometricsIcon;

  /// Widget to be shown on Remove Button
  final Widget? removeIcon;

  /// Creates [LockScreen]
  const LockScreen({
    Key? key,
    required this.validator,
    required this.onUnlock,
    required this.title,
    required this.biometricsTitle,
    this.pinLength = 4,
    this.decoration = const LockScreenDecoration(),
    this.enableBiometrics = false,
    this.askBiometricsAtStart = false,
    this.onWillPop,
    this.onPinInputFinished,
    this.top,
    this.bottom,
    this.biometricsIcon,
    this.removeIcon,
  }) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with PortraitOrientationMixin<LockScreen> {
  late bool _biometricsAskedAtStart;
  late LockScreenBloc _bloc;

  @override
  void initState() {
    super.initState();

    _biometricsAskedAtStart = false;

    final config = LockScreenConfig(
      isPinEnabled: true,
      isPinConfigured: true,
      pinLength: widget.pinLength,
      isBiometricsEnabled: widget.enableBiometrics,
      askBiometricsAtStart: widget.askBiometricsAtStart,
    );

    // init lock screen bloc
    _bloc = LockScreenBloc(config, validator: widget.validator);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _askBiometricsOnInit() {
    if (!_biometricsAskedAtStart) {
      _biometricsAskedAtStart = true;
      _bloc.add(LockScreenEvent.unlockWithBiometrics(widget.biometricsTitle));
    }
  }

  void _onBiometricsPressed() =>
      _bloc.add(LockScreenEvent.unlockWithBiometrics(widget.biometricsTitle));

  void _onNumberKeyPressed(String value) =>
      _bloc.add(LockScreenEvent.inputPin(value));

  void _onRemovePressed() => _bloc.add(const LockScreenEvent.removePin());

  void _onRemoveLongPressed() => _bloc.add(const LockScreenEvent.resetInput());

  LockScreenDecoration get _decoration => widget.decoration;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: widget.onWillPop?.call,
        child: LockScreenBlocScope(
          bloc: _bloc,
          child: LockStateConsumer(
            bloc: _bloc,
            listener: (context, state) {
              if (state.isBadAttempt) return;
              if (state.isUnlocked) return widget.onUnlock();
              if (state.askBiometricsAtStart) _askBiometricsOnInit();

              if (state.isPinInputFinished) {
                Future<void>.delayed(const Duration(milliseconds: 200), () {
                  _bloc.add(LockScreenEvent.unlockWithPin(state.pinValue));
                  widget.onPinInputFinished?.call(state.pinValue);
                });
              }
            },
            builder: (context, state) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: <Widget>[
                  Container(
                    color: _decoration.backgroundColor,
                    child: _decoration.background,
                  ),
                  Positioned.fill(
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          widget.top ?? const SizedBox.shrink(),
                          Text(
                            widget.title,
                            style: _decoration.titleTextStyle ??
                                Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(height: 20),
                          PinArea(
                            decoration: _decoration.pinFieldDecoration,
                          ),
                          if (state.isBadAttempt) ...[
                            const SizedBox(height: 8),
                            ErrorMessage(
                              state.errorMessage,
                              style: _decoration.errorTextStyle,
                              color: _decoration.pinFieldDecoration.errorColor,
                            ),
                          ],
                          const Spacer(),
                          NumPad(
                            decoration: _decoration.numPadDecoration,
                            biometricsIcon: widget.biometricsIcon,
                            removeIcon: widget.removeIcon,
                            onNumberKeyPressed: _onNumberKeyPressed,
                            onRemoveLongPressed: _onRemoveLongPressed,
                            onRemovePressed: _onRemovePressed,
                            onBiometricsPressed: _onBiometricsPressed,
                          ),
                          widget.bottom ?? const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

/// Signature for validating a Lock Screen Pin Code attempt
///
/// Takes [String] which is a Pin Code attempt entered by user
///
/// Returns an error string to display if the Pin Code input is invalid,
/// or null otherwise.
typedef LockScreenPinValidator = Future<String?> Function(String);
