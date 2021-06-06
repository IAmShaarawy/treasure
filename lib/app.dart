import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:treasure/models/roles.dart';
import 'package:treasure/screens/admin_home.dart';
import 'package:treasure/screens/auth.dart';
import 'package:treasure/screens/splash.dart';
import 'package:treasure/screens/user_home.dart';
import 'package:treasure/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

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
        stream: findHome(),
        builder: (context, screenData) => screenData.data,
      ),
    );
  }

  Stream<Widget> findHome() {
    return initApp().asStream().delay(Duration(seconds: 2)).flatMap((app) {
      return AuthService().getCurrentUserStream().map((user) {
        if (user == null) return Auth();
        if (user.role == Roles.ADMIN) return AdminHome();
        return UserHome();
      });
    });
  }

  Future<FirebaseApp> initApp() async {
    return await Firebase.initializeApp();
  }
}
