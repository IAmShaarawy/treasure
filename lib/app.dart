import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:treasure/screens/auth.dart';
import 'package:treasure/screens/splash.dart';
import 'package:treasure/screens/treasure_details.dart';

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
    await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 3));
    return TreasureDetails();
  }
}
