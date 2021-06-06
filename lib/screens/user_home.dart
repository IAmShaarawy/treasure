import 'package:flutter/material.dart';
import 'package:treasure/screens/profile.dart';
import 'package:treasure/screens/treasures.dart';


class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _currentIndex = 0;
  final _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance),
      label: "Treasures",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    )
  ];

  final _screens = <Widget>[
    Treasures(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: _items,
        onTap: _onItemTap,
      ),
    );
  }

  void _onItemTap(int itemIndex) {
    setState(() {
      _currentIndex = itemIndex;
    });
  }
}
