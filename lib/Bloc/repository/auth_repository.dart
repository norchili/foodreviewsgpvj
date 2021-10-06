import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_api/firebase_auth_api.dart';

class AuthRepository {
  final _firebaseAuthApi = FirebaseAuthAPI();
  Future<UserCredential?> signInFirebase() => _firebaseAuthApi.signIn();
  Future<UserCredential> signInWithFacebook() =>
      _firebaseAuthApi.signInWithFacebook();
  Future<User?> currentUser() => _firebaseAuthApi.currentUser();
  void signOut() => _firebaseAuthApi.signOut();
  Stream<User?> get authStatus => _firebaseAuthApi.authStatus;
}
