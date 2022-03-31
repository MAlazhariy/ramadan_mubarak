
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List> getFirebaseData() async {
  // Get data from docs and convert map to List
  QuerySnapshot collection =
      await FirebaseFirestore.instance.collection('users').orderBy('time').get();

  return collection.docs.map((doc) => doc.data()).toList();
}