import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Metodo para inciar sesion primero en Google y luego en firebase
  Future<UserCredential?> signIn() async {
    GoogleSignInAccount? googleSignInAccount;

    //Primera autenticacion con Google
    // Trigger the authentication flow
    try {
      googleSignInAccount = await googleSignIn
          .signIn(); //aparece ventana o cuadro de dialogo para seleccionar cuenta de Google
    } catch (error) {
      googleSignInAccount = null;
      log("Error al mostrar la ventana de cuentas de Google: ",
          error: error, name: "Autenticacion: Google Sign In");
    }
    // Obtain the auth details from the request
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication? googleAuthentication;
      try {
        googleAuthentication = await googleSignInAccount
            .authentication; //Obtenemos las credenciales de la cuenta de Goolge seleccionada
      } catch (error) {
        log("Error al obtener las credenciales de la cuenta de Google: ",
            error: error, name: "Autenticacion: Google Sign In");
      }

      OAuthCredential? credential;
      // Create a new credential
      if (googleAuthentication != null) {
        credential = GoogleAuthProvider.credential(
            accessToken: googleAuthentication.accessToken,
            idToken: googleAuthentication.idToken);
      } else {
        log("Objeto credentials vacio: ",
            name: "Autenticacion: Google Sign In");
      }

      //Segunda autenticacion con Firebase
      // Once signed in on Google, return the UserCredential of Firebase
      if (credential != null) {
        try {
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          return userCredential;
        } catch (e) {
          log("Error al autenticar con firebase: ",
              error: e, name: "Autenticacion: Firebase");
        }
      }
    } else {
      return null;
    }
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
}
