import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure/models/categories.dart';

class TreasureModel {
  final String id;
  final Categories category;
  final String title;
  final String desc;
  final int since;
  final List<String> imagesURLS;
  final List<String> viewersIds;
  final bool isReviewed;
  final LatLng location;

  TreasureModel(
      {this.id,
      this.category,
      this.title,
      this.desc,
      this.since,
      this.imagesURLS,
      this.viewersIds,
      this.isReviewed,
      this.location});

  String sinceFormatted() {
    final trailing = since >= 0 ? "AD" : "BC";
    return "${since.abs()} $trailing";
  }

  TreasureModel copy(
          {String id,
          Categories category,
          String title,
          String desc,
          int since,
          List<String> imagesURLS,
          List<String> viewersIds,
          bool isReviewed,
          LatLng location}) =>
      TreasureModel(
        id: id,
        category: category == null ? this.category : category,
        title: title == null ? this.title : title,
        desc: desc == null ? this.desc : desc,
        since: since == null ? this.since : since,
        imagesURLS: imagesURLS == null ? this.imagesURLS : imagesURLS,
        viewersIds: viewersIds == null ? this.viewersIds : viewersIds,
        isReviewed: isReviewed == null ? this.isReviewed : isReviewed,
        location: location == null ? this.location : location,
      );

  static Map<String, dynamic> toMap(TreasureModel model, SetOptions options) {
    return {
      "category": model.category.toString(),
      "title": model.title,
      "desc": model.desc,
      "since": model.since,
      "images_urls": model.imagesURLS,
      "viewers_ids": model.viewersIds,
      "is_reviewed": model.isReviewed,
      "location": GeoPoint(model.location.latitude, model.location.longitude)
    };
  }

  static TreasureModel from(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions options) {
    if (!doc.exists) return null;
    LatLng location;
    try {
      final geoPoint = (doc.get("location") as GeoPoint);
      location = LatLng(geoPoint.latitude, geoPoint.longitude);
    } catch (e) {}
    return TreasureModel(
      id: doc.id,
      category: categoryFromString(doc.get("category")),
      title: doc.get("title"),
      desc: doc.get("desc"),
      since: doc.get("since"),
      imagesURLS: (doc.get("images_urls") as List).cast<String>(),
      viewersIds: (doc.get("viewers_ids") as List).cast<String>(),
      isReviewed: doc.get("is_reviewed"),
      location: location,
    );
  }
}
