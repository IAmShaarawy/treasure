import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treasure/models/treasure_model.dart';

class TreasureService {
  final treasureCollection = FirebaseFirestore.instance
      .collection("treasures")
      .withConverter<TreasureModel>(
        fromFirestore: TreasureModel.from,
        toFirestore: TreasureModel.toMap,
      );

  Future<void> addNewTreasure(String title, String img, int since) async {
    final doc = treasureCollection.doc();
    final treasure = TreasureModel(
      id: doc.id,
      title: title,
      img: img,
      since: since,
    );
    await doc.set(treasure);
  }

  Future<TreasureModel> getTreasureWithId(String id) async {
    final ds = await treasureCollection.doc(id).get();
    return ds.data();
  }

  Stream<TreasureModel> getTreasureWithIdStream(String id) {
    return treasureCollection.doc(id)
        .snapshots()
        .map((ds) => ds.data());
  }
}
