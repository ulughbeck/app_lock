import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../controller/controller.dart';
import 'bloc_scope.dart';

@immutable
class LockStateConsumer extends StatefulWidget {
  final LockScreenBloc? bloc;
  final LockStateListenerFunc? listener;
  final LockStateBuilderFunc builder;

  const LockStateConsumer({
    required this.builder,
    this.listener,
    this.bloc,
    Key? key,
  }) : super(key: key);

  @override
  _LockStateConsumerState createState() => _LockStateConsumerState();
}

class _LockStateConsumerState extends State<LockStateConsumer> {
  late StreamSubscription<LockScreenState> _sub;
  LockScreenState? _currentState;

  LockScreenBloc get _bloc => widget.bloc ?? context.bloc();

  @override
  void initState() {
    super.initState();
    if (_bloc.currentState != null) {
      _currentState = _bloc.currentState;
    }
    _sub = _bloc.state.listen((state) {
      widget.listener?.call(context, state);
      setState(() => _currentState = state);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentState == null) return const SizedBox.shrink();
    return widget.builder(context, _currentState!);
  }
}

///
typedef LockStateBuilderFunc = Widget Function(BuildContext, LockScreenState);

///
typedef LockStateListenerFunc = void Function(BuildContext, LockScreenState);
