import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodgpvjreviews/Bloc/repository/auth_repository.dart';
import 'package:foodgpvjreviews/Bloc/repository/cloud_firestore_repository.dart';
import 'package:foodgpvjreviews/Bloc/repository/firebase_storage_repository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:foodgpvjreviews/User/model/user.dart' as model_user;

class UserBloc implements Bloc {
  final _authRepository = AuthRepository();
  final _firebaseStorageRepository = FirebaseStorageRepository();
  final _cloudFirestoreRepository = CloudFirestoreRepository();

  //Flujo de datos - Stream
  //Stream - Firebase
  Stream<User?> get authStatus =>
      _authRepository.authStatus; //devuelve el estado de la sesion de Firebase
  /*
  Stream<User?> streamFirebase = FirebaseAuth.instance
      .authStateChanges(); //Establece o instancia que se requiere conocer el estado de la sesion en Firebase

  Stream<User?> get authStatus =>
      streamFirebase; //Devuelve el estado de la sesion
*/

  //Metodo paara devolver el usuario actualmente logueado
  Future<User?> currentUser() {
    return _authRepository.currentUser();
  }

  //Metodo para autenticar en Firebase con las credenciales de Goolge
  Future<UserCredential?> signIn() {
    return _authRepository.signInFirebase();
  }

  void signOut() {
    _authRepository.signOut();
  }

  //Caso de uso
  //Registrar Usuario si no existe o actualizar Usuario si existe en Base de datos de Firestore

  void updateUserData(model_user.User user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);
/*
  Future<void> updateUserPlaceData(Place place) =>
      _cloudFirestoreRepository.updateUserPlaceData(place);

  //Metodo para construir lista de Places despues de haber obtenido los datos de Plaes de CloudFirestore
  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);

  //Metoso para agregar un listener de escucha ante cualquier cambio en la
  //colecion de PLACES
  Stream<QuerySnapshot> placesListStream = FirebaseFirestore.instance
      .collection(CloudFirestoreApi().getPLACES())
      .snapshots();
  Stream<QuerySnapshot> get placesStream =>
      placesListStream; //el metodo get siempre va despues de haber declarado un Stream

  //Metodo para seleccionar solo los PLaces del usuario logueado
  Stream<QuerySnapshot<Map<String, dynamic>>> myPlacesListStream(String uid) =>
      _cloudFirestoreRepository.myPlacesListStream(uid);

  //Metodos para poner escucha al Place sellecionado en la pantalla principal
  StreamController<Place> placeSelectedStreamController = StreamController();
  Stream<Place> get placeSelectedStream => placeSelectedStreamController.stream;
  StreamSink<Place> get placeSelectedSink => placeSelectedStreamController.sink;

  //Metodo pàra obtener todos los Places de la Base de datos
  List<Place> buildPlaces(
          List<DocumentSnapshot> placesListSnapshot, userModel.User user) =>
      _cloudFirestoreRepository.buildPlaces(placesListSnapshot, user);

  //Metodo para incrementar los like de un Place
  Future likePlace(Place place, String userId) =>
      _cloudFirestoreRepository.likePlace(place, userId);
      */

  //Metodo para Guardar imagen en la FirebaseStorage
  Future<UploadTask> uploadFile(String path, File image) =>
      _firebaseStorageRepository.uploadFile(path, image);

  @override
  void dispose() {
    //placeSelectedStreamController.close();
  }
}
