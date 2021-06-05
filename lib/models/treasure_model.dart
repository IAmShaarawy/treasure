import 'package:cloud_firestore/cloud_firestore.dart';

class TreasureModel {
  final String id;
  final String title;
  final int since;
  final String img;

  TreasureModel({this.id, this.title, this.since, this.img});

  static Map<String, dynamic> toMap(TreasureModel model,SetOptions options) {
    return {
      "title": model.title,
      "img": model.img,
      "since": model.since,
    };
  }

  static TreasureModel from(DocumentSnapshot<Map<String,dynamic>> doc,SnapshotOptions options) {
    if (!doc.exists) return null;
    return TreasureModel(
      id: doc.id,
      title: doc.get("title"),
      img: doc.get("img"),
      since: doc.get("since"),
    );
  }
}
