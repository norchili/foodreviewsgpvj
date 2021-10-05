import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodgpvjreviews/Bloc/firebase_api/firebase_storage_api.dart';

class FirebaseStorageRepository {
  final _firebaseStorageApi = FirebaseStorageApi();

  Future<UploadTask> uploadFile(String path, File image) =>
      _firebaseStorageApi.uploadFile(path, image);
}
