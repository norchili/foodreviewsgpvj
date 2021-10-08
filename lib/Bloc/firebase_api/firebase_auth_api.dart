import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:foodgpvjreviews/responses/sign_in_response.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  //Metodo para inciar sesion primero en Google y luego en firebase
  Future<SignInResponse> signIn() async {
    GoogleSignInAccount? googleSignInAccount;

    //Primera autenticacion con Google
    // Trigger the authentication flow
    try {
      googleSignInAccount =
          await googleSignIn.signIn().onError((error, stackTrace) {
        log("Error", error: error, stackTrace: stackTrace);
      }); //aparece ventana o cuadro de dialogo para seleccionar cuenta de Google

      if (googleSignInAccount == null) {
        return SignInResponse(
            error: SignInError.cancelled, user: null, providerId: null);
      }
      // Obtain the auth details from the request
      GoogleSignInAuthentication? googleAuthentication;

      googleAuthentication = await googleSignInAccount
          .authentication; //Obtenemos las credenciales de la cuenta de Goolge seleccionada

      // Create a new credential
      OAuthCredential? credential;

      credential = GoogleAuthProvider.credential(
          accessToken: googleAuthentication.accessToken,
          idToken: googleAuthentication.idToken);

      //Segunda autenticacion con Firebase
      // Once signed in on Google, return the UserCredential of Firebase
      //UserCredential userCredential =
      //   await _auth.signInWithCredential(credential);
      return signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      return getSignInError(e);
    }
  }

  //Metodo para autenticar con facebook en firebase
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await facebookAuth.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return _auth.signInWithCredential(facebookAuthCredential);
  }

  //Metodo para obtener el usuario actualmente logueado
  Future<User?> currentUser() async {
    return _auth.currentUser;
  }

  Stream<User?> streamFirebase = FirebaseAuth.instance
      .authStateChanges(); //Establece o instancia que se requiere conocer el estado de la sesion en Firebase

  Stream<User?> get authStatus =>
      streamFirebase; //Devuelve el estado de la sesion

  //Metodo para cerrar la sesion en Firebase y Google
  void signOut() async {
    //await facebookAuth.logOut();
    await googleSignIn.signOut().then((value) {
      log("Sesion de Google cerrada: $value",
          name: "Autenticacion: Google Sign Out");
    }).onError((error, stackTrace) {
      log("Error al cerrar la sesión de Google",
          error: error,
          stackTrace: stackTrace,
          name: "Autenticacion: Google Sign Out");
    });
    await _auth.signOut().then((value) {
      log("Sesión de Firebase Cerrada");
    }).onError((error, stackTrace) {
      log("Error al cerrar la sesión de Firebase",
          error: error,
          stackTrace: stackTrace,
          name: "Autenticacion: Firebase Sign Out");
    });
  }

  Future<SignInResponse> signInWithCredential(
      OAuthCredential credential) async {
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user!;
    return SignInResponse(
        error: null,
        user: user,
        providerId: userCredential.credential?.providerId);
  }
}
