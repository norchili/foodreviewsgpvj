import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageApi {
  final Reference _storageReference = FirebaseStorage.instance.ref();

  Future<UploadTask> uploadFile(String path, File image) async {
    UploadTask storageUploadTask = _storageReference.child(path).putFile(image);
    return storageUploadTask;
  }

  Future<String?> getUrlLogo(String nameLogo) async {
    String path = "logos/$nameLogo.jpg";
    //String? urlLogo;
    await _storageReference.child(path).getDownloadURL().then((value) {
      return value;
    });

    //return urlLogo;
  }

  Future<Map<String, String>> getUrlLogos() async {
    //String path = "logos/$nameLogo.jpg";
    Map<String, String> urlLogos2 = {};
    ListResult result = await _storageReference.listAll();
    List<Map<String, String>> urlLogos = [];

    for (var reference in result.items) {
      if (reference.name.contains("facebook")) {
        await reference.getDownloadURL().then((urlLogo) {
          urlLogos.add({'facebook': urlLogo});
          urlLogos2.update('facebook', (value) => urlLogo);
        }).onError((error, stackTrace) {
          log("Error al obtener el logo de facebook: ",
              error: error,
              stackTrace: stackTrace,
              name: "Error de Firebase Storage");
        });
      } else {
        if (reference.name.contains("google")) {
          await reference.getDownloadURL().then((urlLogo) {
            urlLogos.add({'google': urlLogo});
            urlLogos2.update('google', (value) => urlLogo);
          }).onError((error, stackTrace) {
            log("Error al obtener el logo de Google: ",
                error: error,
                stackTrace: stackTrace,
                name: "Error de Firebase Storage");
          });
        }
      }
    }
    return urlLogos2;
  }
}
