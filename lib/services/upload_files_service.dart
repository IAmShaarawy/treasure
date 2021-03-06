import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:treasure/services/auth_service.dart';


class UploadFileService {
  final _profileImagesRef =
  FirebaseStorage.instance.ref("images").child("profile");

  final _treasuresImagesRef =
  FirebaseStorage.instance.ref("images").child("treasures");

  final _authService = AuthService();

  Future<String> uploadProfileImage(String filePath) async {
    if (filePath == null) return null;
    final currentUser = await _authService.getCurrentUser();
    final imageFile = File(filePath);
    final uploadResult = await _profileImagesRef
        .child(DateTime.now().millisecondsSinceEpoch.toString() +
        currentUser.id )
        .putFile(imageFile);
    return await uploadResult.ref.getDownloadURL();
  }

  Future<String> uploadTreasureImage(String filePath) async {
    if (filePath == null) return null;
    final currentUser = await _authService.getCurrentUser();
    final imageFile = File(filePath);
    final uploadResult = await _treasuresImagesRef
        .child(DateTime.now().millisecondsSinceEpoch.toString() +
        currentUser.id )
        .putFile(imageFile);
    return await uploadResult.ref.getDownloadURL();
  }
}
