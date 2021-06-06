
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treasure/models/app_user.dart';
import 'package:treasure/models/roles.dart';
import 'package:treasure/services/auth_service.dart';
import 'package:treasure/services/upload_files_service.dart';
import 'package:treasure/services/user_service.dart';
import 'package:treasure/ui/dialog/edit_name.dart';
import 'package:treasure/ui/loading.dart';

class UserProfile extends StatelessWidget {
  final authService = AuthService();
  final uploadService = UploadFileService();
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<AppUser>(
        stream: authService.getCurrentUserStream(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Loading()
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => editImage(snapshot.data),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data.imgURL,
                        ),
                        maxRadius: 64,
                        minRadius: 64,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54),
                        child: Icon(
                          Icons.edit,
                          color: _roleColor(snapshot.data),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      snapshot.data.name,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: _roleColor(snapshot.data),
                      ),
                      onPressed: () => editName(context, snapshot.data),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Your account role is: "),
                    Text(
                      snapshot.data.roleLabel(),
                      style: TextStyle(color: _roleColor(snapshot.data)),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void editImage(AppUser user) async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    try {
      final imgURL = await uploadService.uploadProfileImage(pickedFile.path);
      userService.editUser(user.copy(imgUrl: imgURL));
    } catch (e) {
      print(e);
    } finally {}
  }

  void editName(BuildContext context, AppUser user) async {
    String name = await showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        child: EditName(
          name: user.name,
        ),
      ),
    );

    try {
      userService.editUser(user.copy(name: name));
    } catch (e) {
      print(e);
    } finally {}
  }

  Color _roleColor(AppUser appUser) {
    if (appUser.role == Roles.ADMIN) return Colors.red;
    return Colors.blue;
  }

  void _logout() async {
    await AuthService().signOut();
  }
}
