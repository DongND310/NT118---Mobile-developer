import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class UtilsService {
  Future<String> uploadFile(File _file, String path) async {
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref(path);

    firebase_storage.UploadTask uploadTask = storageReference.putFile(_file);

    await uploadTask.whenComplete(() => null);
    String returnURL = '';
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }
}
