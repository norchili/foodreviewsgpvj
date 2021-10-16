import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgpvjreviews/responses/sign_in_response.dart';

import '../firebase_api/firebase_auth_api.dart';

class AuthRepository {
  final _firebaseAuthApi = FirebaseAuthAPI();
  Future<SignInResponse> signInFirebase() => _firebaseAuthApi.signIn();

  Future<UserCredential> signInWithFacebook() =>
      _firebaseAuthApi.signInWithFacebook();

  Future<SignInResponse> signInWithEmailAndPassword(
          String email, String password) =>
      _firebaseAuthApi.signInWithEmailAndPassword(email, password);

  Future<User?> currentUser() => _firebaseAuthApi.currentUser();

  void signOut() => _firebaseAuthApi.signOut();

  Stream<User?> get authStatus => _firebaseAuthApi.authStatus;
}
