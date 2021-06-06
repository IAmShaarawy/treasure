import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:treasure/models/app_user.dart';
import 'package:treasure/services/user_service.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _userService = UserService();

  Stream<AppUser> getCurrentUserStream() {
    return _auth.authStateChanges().flatMap<AppUser>((firebaseUser) {
      if (firebaseUser == null) return Stream.value(null);
      return _userService.getUserStream(firebaseUser.uid);
    });
  }

  Future<AppUser> getCurrentUser() async {
    final currentUserId = _auth.currentUser.uid;
    return await _userService.getUser(currentUserId);
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _userService.addFirebaseUser(userCred.user);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
