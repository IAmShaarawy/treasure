import 'package:flutter/material.dart';
import 'package:treasure/screens/auth.dart';
import 'package:treasure/screens/splash.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StreamBuilder<Widget>(
        initialData: Splash(),
        stream: findHome().asStream(),
        builder: (context, screenData) => screenData.data,
      ),
    );
  }

  Future<Widget> findHome() async {
    await Future.delayed(Duration(seconds: 3));
    return Auth();
  }
}
