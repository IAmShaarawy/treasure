import 'package:flutter/material.dart';
import 'package:treasure/screens/add_new_treasure.dart';

class Treasures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Treasures"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Treasures"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _onAddTreasure(context),
      ),
    );
  }

  void _onAddTreasure(BuildContext context) {
    Navigator.of(context).pushNamed(AddNewTreasure.ROUTE);
  }
}
