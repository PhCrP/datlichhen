import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  UserEntity? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserEntity(id: user.uid, email: user.email);
  }

  Stream<UserEntity?> get user =>
      _firebaseAuth.authStateChanges().map(_userFromFirebase);

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
