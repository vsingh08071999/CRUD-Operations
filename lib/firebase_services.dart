import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  Future<void> uploadingData(String value) async {
    await FirebaseFirestore.instance.collection("Crud").doc("1").set({
      'array': FieldValue.arrayUnion([value])
    }, SetOptions(merge: true));
  }

  Future<List<String>> getData() async {
    List<String> list = [];
    var data =
        await FirebaseFirestore.instance.collection("Crud").doc("1").get();
    if (data.exists) {
      data.data()!['array'].forEach((element) {
        list.add(element);
      });
    }
    return list;
  }
}
