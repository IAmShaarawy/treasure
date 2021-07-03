import 'package:flutter/material.dart';
import 'package:treasure/models/treasure_model.dart';

class TreasureItem extends StatelessWidget {
  final TreasureModel model;

  TreasureItem(this.model);

  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text(model.title)),
      ),
    );
  }
}
