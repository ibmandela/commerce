import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/common/functions.dart';
import 'package:path_provider/path_provider.dart';

class StorageFirebase {
  final _reference = FirebaseStorage.instance;
  Future<String> uploadFile(file, userUid, BuildContext context) async {
    String path = "";
    final ref = _reference.ref().child("$userUid.png");
    try {
      if (kIsWeb) {
        await ref.putData(file, SettableMetadata(contentType: "image/png"));
        path = await ref.getDownloadURL();
      } else {
        await ref.putFile(file, SettableMetadata(contentType: "image/png"));
        path = await ref.getDownloadURL();
      }
    } on FirebaseException catch (e) {
      
      if (context.mounted) {
        errorDialog(context, "de téléchargement\n ${e.code}");
      }
    }
    return path;
  }

  Future<String> downloadFile(String userUid, context) async {
    var root = await getApplicationSupportDirectory();
    String path = "";
    final httpsReference = _reference.ref().child("$userUid.jpg");

    File downloadFile = Platform.isWindows
        ? File("${root.path}/profile.jpg".replaceAll("/", "\\"))
        : File("${root.path}/profile.jpg");
    try {
      path = await httpsReference
          .writeToFile(downloadFile)
          .then((value) => downloadFile.path);
    } on FirebaseException catch (e) {
      errorDialog(context, "Erreur lors du téléchargement:\n${e.code}");
    }
    return path;
  }

  Future<Uint8List> downloadWebFile(String url, context) async {
    final httpsReference = _reference.refFromURL(url);
    Uint8List file;

    try {
      file = await httpsReference.getData(2500000) ?? Uint8List(10000);
    } on FirebaseException catch (e) {
      return errorDialog(context, "Erreur lors du téléchargement:\n${e.code}");
    }
    return file;
  }
}
