import 'package:flutter/material.dart';

class AddNewTreasure extends StatelessWidget {
  static const ROUTE = "new_treasure_route";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new treasure"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Add new treasure"),
      ),
    );
  }
}
