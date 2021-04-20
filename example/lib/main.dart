import 'package:app_lock/app_lock.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

@immutable
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AppLocker(
        pinLength: 4,
        enableBiometrics: true,
        askBiometricsAtStart: true,
        placeholder: const Scaffold(
          body: Center(
            child: Text('splash'),
          ),
        ),
        child: const MaterialApp(
          title: 'Flutter App Lock Demo',
          home: HomePage(),
        ),
      );
}

@immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('App Locker Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => showAppLockerSettings(context),
                child: const Text('app locker settings'),
              ),
              ElevatedButton(
                onPressed: AppLocker.of(context).setup,
                child: const Text('setup app locker'),
              ),
              ElevatedButton(
                onPressed: AppLocker.of(context).setNewPin,
                child: const Text('set new pin code'),
              ),
              ElevatedButton(
                onPressed: AppLocker.of(context).changePinCode,
                child: const Text('change pin code'),
              ),
              ElevatedButton(
                onPressed: AppLocker.of(context).lockApp,
                child: const Text('lock app'),
              ),
              ElevatedButton(
                onPressed: AppLocker.of(context).resetAppLocker,
                child: const Text('reset app locker'),
              ),
              const Divider(height: 50),
              Text('current pin $_currentPin'),
              ElevatedButton(
                onPressed: _showPin,
                child: const Text('show pin'),
              ),
              ElevatedButton(
                onPressed: _unlockAndPushSecretPage,
                child: const Text('secret page'),
              ),
            ],
          ),
        ),
      );

  final _currentPin = '0000';

  Future<void> _showPin() async {
    final result = await showLockScreen(
      context,
      correctPin: _currentPin,
    );
    print(result);
  }

  void _unlockAndPushSecretPage() => unlockAndPush(
        context,
        MaterialPageRoute<void>(builder: (_) => SecretPage()),
        correctPin: _currentPin,
        decoration: const LockScreenDecoration(
          numPadDecoration: NumpadDecoration(
            btnShape: CircleBorder(),
          ),
        ),
      );
}

class SecretPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('secret'),
        ),
      );
}
