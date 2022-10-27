import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations/model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  Future<void> uploadingData(TaskModel value) async {
    await FirebaseFirestore.instance
        .collection("Title")
        .doc(value.docID)
        .set(value.toJson(), SetOptions(merge: true));
  }

  Future<List<TaskModel>> getData() async {
    List<TaskModel> list = [];
    var data = await FirebaseFirestore.instance.collection("Title").get();
    if (data.docs.isNotEmpty) {
      data.docs.forEach((element) {
        TaskModel model = TaskModel.fromJson(element.data());
        list.add(model);
      });
    }
    return list;
  }

  Future<String> uploadingImageDataToFirebaseStorage(
      File? file, String fileName) async {
    final _firebaseStorage = FirebaseStorage.instance;
    var snapshot =
        await _firebaseStorage.ref().child('images/$fileName').putFile(file!);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    print("Image Url is ${downloadUrl}");
    return downloadUrl.toString();
  }
}
