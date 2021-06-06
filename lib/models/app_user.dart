import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treasure/models/roles.dart';

class AppUser {
  final String id;
  final String email;
  final String imgURL;
  final String name;
  final Roles role;

  AppUser(
      {this.id, this.email, this.imgURL, this.name, this.role,});

  String roleLabel() => rolesLabel(this.role);

  AppUser copy(
          {String email,
          String imgUrl,
          String name,
          Roles role,
         }) =>
      AppUser(
        id: id,
        email: email == null ? this.email : email,
        imgURL: imgUrl == null ? this.imgURL : imgUrl,
        name: name == null ? this.name : name,
        role: role == null ? this.role : role,
      );

  // serialization
  static Map<String, dynamic> toMap(AppUser model,SetOptions options) => {
        "email": model.email,
        "img_url": model.imgURL,
        "name": model.name,
        "role": model.role.toString(),
      };

  // deserialization
  static AppUser from(DocumentSnapshot<Map<String,dynamic>> doc,SnapshotOptions options) {
    if (!doc.exists) return null;

    return AppUser(
      id: doc.id,
      email: doc.get("email"),
      imgURL: doc.get("img_url"),
      name: doc.get("name"),
      role: roleFromString(doc.get("role")),
    );
  }
}
