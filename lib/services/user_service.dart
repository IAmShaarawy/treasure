import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:treasure/models/app_user.dart';
import 'package:treasure/models/roles.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  final _usersCollection = FirebaseFirestore.instance
      .collection("users")
      .withConverter(fromFirestore: AppUser.from, toFirestore: AppUser.toMap);
  final _auth = FirebaseAuth.instance;

  Future<AppUser> addFirebaseUser(User firebaseUser) async {
    String userId = firebaseUser.uid;
    final newUser = AppUser(
      id: userId,
      email: firebaseUser.email,
      role: Roles.USER,
      name: "User ${userId.substring(0, 4)}",
      imgURL: "https://picsum.photos/seed/$userId/200",
    );
    await addNewUser(newUser);
    return newUser;
  }

  Future<AppUser> getCurrentUser() async {
    final currentUserId = _auth.currentUser.uid;
    return await getUser(currentUserId);
  }

  Future<void> addNewUser(AppUser user) async {
    await _usersCollection.doc(user.id).set(user);
  }

  Future<AppUser> getUser(String userId) async {
    if (userId == null) return null;
    final ds = await _usersCollection.doc(userId).get();
    return ds.data();
  }

  Stream<AppUser> getUserStream(String userId) {
    if (userId == null) return Stream.value(null);
    return _usersCollection
        .doc(userId)
        .snapshots()
        .map((ds) => ds.data());
  }

  Stream<List<AppUser>> getAllUsersStream() {
    return _auth.authStateChanges().flatMap((currentUser) => _usersCollection
        .snapshots()
        .map((qs) => qs.docs)
        .map((docs) => docs
            .map((ds) => ds.data())
            .where((user) => user.id != currentUser.uid)
            .toList()));
  }

  Future<void> editUser(AppUser appUser) async {
    await _usersCollection.doc(appUser.id).set(appUser);
  }
}
