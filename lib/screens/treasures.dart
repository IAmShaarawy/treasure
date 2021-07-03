import 'package:flutter/material.dart';
import 'package:treasure/models/categories.dart';
import 'package:treasure/models/treasure_model.dart';
import 'package:treasure/screens/add_new_treasure.dart';
import 'package:treasure/services/treasure_service.dart';
import 'package:treasure/ui/loading.dart';
import 'package:treasure/ui/treasure_item.dart';

class Treasures extends StatefulWidget {
  final treasuresService = TreasureService();

  @override
  _TreasuresState createState() => _TreasuresState();
}

class _TreasuresState extends State<Treasures> {
  Categories _selectedCategory = Categories.values.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monuments"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCategorySelector(),
          Expanded(
            child: Center(child: _buildTreasuresList(_selectedCategory)),
          )
        ],
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

  Widget _buildCategorySelector() {
    return Container(
      height: 64,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: Categories.values.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = Categories.values[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              avatar: CircleAvatar(
                backgroundImage: NetworkImage(
                  categoryImage(category),
                ),
              ),
              label: Text(categoryLabel(category)),
              selected: _selectedCategory == category,
              onSelected: (isSelected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTreasuresList(Categories category) {
    return StreamBuilder<List<TreasureModel>>(
        stream: widget.treasuresService.getReviewedTreasuresStream(category),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Loading();
          final treasures = snapshot.data;
          if (treasures.isEmpty) return Text("Empty!!!");
          return ListView.builder(
              itemCount: treasures.length,
              itemBuilder: (context, index) {
                return TreasureItem(treasures[index]);
              });
        });
  }
}
