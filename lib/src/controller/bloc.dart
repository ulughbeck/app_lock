import 'dart:async';

/// Bloc Interface
///
/// E = event
///
/// S = state
abstract class Bloc<E, S> {
  /// constructor can be provided with initial state
  Bloc([S? initialState]) {
    _sub = _events.listen(mapEventToState);
    if (initialState != null) {
      _currentState = initialState;
    }
  }

  /// Event [E] stream
  final _event = StreamController<E>();
  Stream<E> get _events => _event.stream;

  /// add new Event [E] to bloc
  void add(E event) => _event.sink.add(event);
  late StreamSubscription _sub;

  final _state = StreamController<S>.broadcast();

  /// State [S] stream
  Stream<S> get state => _state.stream;
  S? _currentState;

  /// Returns last state [S]
  S? get currentState => _currentState;

  /// Emit new state [S] to the stream
  void emit(S state) {
    _currentState = state;
    _state.sink.add(state);
  }

  /// dispose streams and subscriptions
  void dispose() {
    _sub.cancel();
    _state.close();
    _event.close();
  }

  /// Mappper of events to states
  void mapEventToState(E event) {}
}
