import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platform_device_id/platform_device_id.dart';

Future<QuerySnapshot<Map<String, dynamic>>> getCollection() async {
  return await FirebaseFirestore.instance
      .collection('users')
      .orderBy('time')
      // .where('approved', isEqualTo: true)
      .get();
}

Future<QuerySnapshot<Map<String, dynamic>>> getNotApprovedCollection() async {
  return await FirebaseFirestore.instance
      .collection('users')
      .orderBy('time')
      .where('approved', isEqualTo: false)
      .get();
}

Future<QuerySnapshot<Map<String, dynamic>>> getUpdatedCollection() async {
  return await FirebaseFirestore.instance
      .collection('users')
      .orderBy('time')
      .where('pendingEdit', isEqualTo: true)
      .get();
}

Future<List> getFirebaseData([
  QuerySnapshot collection,
]) async {
  QuerySnapshot myCollection;

  if (collection != null) {
    myCollection = collection;
  } else {
    // Get data from docs and convert map to List
    myCollection = await getCollection();
  }

  List data = myCollection.docs.map((doc) => doc.data()).toList();
  return data.where((element) => element['approved'] == true).toList();
}
