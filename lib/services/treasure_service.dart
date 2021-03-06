import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure/models/categories.dart';
import 'package:treasure/models/roles.dart';
import 'package:treasure/models/treasure_model.dart';
import 'package:treasure/services/auth_service.dart';
import 'package:treasure/services/upload_files_service.dart';

class TreasureService {
  final _treasureCollection = FirebaseFirestore.instance
      .collection("treasures")
      .withConverter<TreasureModel>(
        fromFirestore: TreasureModel.from,
        toFirestore: TreasureModel.toMap,
      );

  final _uploadService = UploadFileService();
  final _authService = AuthService();

  Future<void> addNewTreasure({
    Categories category,
    String title,
    String desc,
    int since,
    List<String> imagesPaths,
    LatLng location,
  }) async {
    final urls = await Future.wait(imagesPaths
        .map((imgPath) => _uploadService.uploadTreasureImage(imgPath)));
    final currentUser = await _authService.getCurrentUser();
    final doc = _treasureCollection.doc();
    final treasure = TreasureModel(
        id: doc.id,
        category: category,
        title: title,
        desc: desc,
        since: since,
        imagesURLS: urls,
        viewersIds: [],
        isReviewed: currentUser.role == Roles.ADMIN,
        location: location);
    await doc.set(treasure);
  }

  Future<TreasureModel> getTreasureWithId(String id) async {
    final ds = await _treasureCollection.doc(id).get();
    return ds.data();
  }

  Stream<TreasureModel> getTreasureWithIdStream(String id) {
    return _treasureCollection.doc(id).snapshots().map((ds) => ds.data());
  }

  Future<void> deleteTreasure(String treasureId) async {
    await _treasureCollection.doc(treasureId).delete();
  }

  Stream<List<TreasureModel>> getReviewedTreasuresStream(Categories category) {
    return _getTreasuresStream(true, category);
  }

  Stream<List<TreasureModel>> getNotReviewedTreasuresStream(
      Categories category) {
    return _getTreasuresStream(false, category);
  }

  Stream<List<TreasureModel>> _getTreasuresStream(
      bool isReviewed, Categories category) {
    Query<TreasureModel> query =
        _treasureCollection.where("is_reviewed", isEqualTo: isReviewed);
    if (category != null) {
      query = query.where("category", isEqualTo: category.toString());
    }
    return query.snapshots().map((qs) {
      return qs.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> setTreasureSeenByCurrentUser(String treasureId) async {
    final treasure = await getTreasureWithId(treasureId);
    final currentUser = await _authService.getCurrentUser();
    if (treasure.viewersIds.contains(currentUser.id)) return;
    treasure.viewersIds.add(currentUser.id);
    await _treasureCollection
        .doc(treasureId)
        .update({"viewers_ids": treasure.viewersIds});
  }

  Future<void> setTreasureReviewed(String treasureId) async {
    await _treasureCollection.doc(treasureId).update({"is_reviewed": true});
  }
}
