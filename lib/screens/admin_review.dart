import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:treasure/models/treasure_model.dart';
import 'package:treasure/services/treasure_service.dart';
import 'package:treasure/ui/loading.dart';
import 'package:treasure/ui/treasure_item.dart';

class AdminReview extends StatelessWidget {
  final treasuresService = TreasureService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
        centerTitle: true,
      ),
      body: Center(
        child: _buildTreasuresList(),
      ),
    );
  }

  Widget _buildTreasuresList() {
    return StreamBuilder<List<TreasureModel>>(
        stream: treasuresService.getNotReviewedTreasuresStream(null),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Loading();
          final treasures = snapshot.data;
          if (treasures.isEmpty) return SizedBox(
            width: 250.0,
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 35,
                  color: Colors.amber,
                  shadows: [
                    Shadow(
                      blurRadius: 7.0,
                      color: Colors.amber,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FlickerAnimatedText('NO REVIEWS'),
                  ],
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ),
          );
          return ListView.builder(
              padding: EdgeInsets.all(4),
              itemCount: treasures.length,
              itemBuilder: (context, index) {
                return TreasureItem(treasures[index], true);
              });
        });
  }
}
