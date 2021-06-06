import 'package:flutter/material.dart';
import 'package:treasure/models/treasure_model.dart';
import 'package:treasure/services/treasure_service.dart';
import 'package:treasure/ui/loading.dart';

class TreasureDetails extends StatelessWidget {
  final treasureService = TreasureService();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: StreamBuilder<TreasureModel>(
              stream: treasureService.getTreasureWithIdStream("t1h2yQAWPFoFoARZijYb"),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text(snapshot.error.toString());
                if (!snapshot.hasData) return Loading();
                final treasure = snapshot.data;
                return Column(
                  children: [
                    Text(treasure.title),
                    Image.network(
                      treasure.img,
                      width: 300,
                    ),
                    Text("Since: ${treasure.since}"),
                    Text("${treasure.id}"),
                    ElevatedButton(
                        onPressed: onPressButton,
                        child: Text("Add a new treasure"))
                  ],
                );
              })),
    );
  }

  void onPressButton() async {
    await treasureService.addNewTreasure("Fouad", "https://www.egypttoday.com/siteimages/Larg/20201115122202222.jpg", 1997);
  }
}
