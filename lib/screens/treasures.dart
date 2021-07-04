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
        title: Text("Home"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Stack(
        children: [
          Center(child: _buildTreasuresList(_selectedCategory)),
          _buildCategorySelector(),
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
      color: Colors.amber.shade300.withAlpha(80),
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
        stream: widget.treasuresService.getReviewedTreasuresStream(null),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Loading();
          final treasures = snapshot.data;
          if (treasures.isEmpty) return Text("Empty!!!");
          return ListView.builder(
              padding: EdgeInsets.only(bottom: 84, top: 64, left: 4, right: 4),
              itemCount: treasures.length,
              itemBuilder: (context, index) {
                return TreasureItem(treasures[index], false);
              });
        });
  }
}
