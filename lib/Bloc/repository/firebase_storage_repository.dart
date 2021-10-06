import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodgpvjreviews/Bloc/firebase_api/firebase_storage_api.dart';

class FirebaseStorageRepository {
  final _firebaseStorageApi = FirebaseStorageApi();

  Future<UploadTask> uploadFile(String path, File image) =>
      _firebaseStorageApi.uploadFile(path, image);

  Future<Map<String, String>> getUrlLogos() =>
      _firebaseStorageApi.getUrlLogos();

  Future<String?> getUrlLogo(String nameLogo) =>
      _firebaseStorageApi.getUrlLogo(nameLogo);
}
