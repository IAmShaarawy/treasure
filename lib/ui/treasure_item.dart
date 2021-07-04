import 'package:flutter/material.dart';
import 'package:treasure/models/categories.dart';
import 'package:treasure/models/treasure_model.dart';
import 'package:treasure/screens/treasure_details.dart';
import 'package:treasure/services/treasure_service.dart';

class TreasureItem extends StatelessWidget {
  final TreasureModel model;
  final bool isWithAdminControllers;
  final _treasureService = TreasureService();

  TreasureItem(this.model, this.isWithAdminControllers);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openDetails(context),
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          children: [
            Image.network(
              model.imagesURLS.first,
              height: 256,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                model.title,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(model.sinceFormatted()),
                      ),
                    ],
                  ),
                  isWithAdminControllers
                      ? RawChip(
                          avatar: CircleAvatar(
                            backgroundImage: NetworkImage(
                              categoryImage(model.category),
                            ),
                          ),
                          label: Text(categoryLabel(model.category)),
                        )
                      : Row(
                          children: [
                            Icon(Icons.remove_red_eye),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(model.viewersIds.length.toString()),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            isWithAdminControllers ? _buildAdminControllers() : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildAdminControllers() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: deleteTreasure,
              icon: Icon(
                Icons.cancel,
                size: 32,
                color: Colors.red,
              )),
          IconButton(
              onPressed: acceptTreasure,
              icon: Icon(
                Icons.check_circle,
                size: 32,
                color: Colors.green,
              ))
        ],
      ),
    );
  }

  void openDetails(BuildContext context) {
    Navigator.of(context).pushNamed(TreasureDetails.ROUTE, arguments: model);
  }

  void deleteTreasure() {
    _treasureService.deleteTreasure(model.id);
  }

  void acceptTreasure() {
    _treasureService.setTreasureReviewed(model.id);
  }
}
