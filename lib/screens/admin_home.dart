import 'package:flutter/material.dart';
import 'package:treasure/screens/admin_review.dart';
import 'package:treasure/screens/profile.dart';
import 'package:treasure/screens/treasures.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;
  final _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance),
      label: "Treasures",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.reviews),
      label: "Reviews",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    )
  ];

  final _screens = <Widget>[
    Treasures(),
    AdminReview(),
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
