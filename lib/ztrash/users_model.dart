// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserDocsModel {
//   int length = 0;
//   List<UserDataModel> data = [];
//
//   UserDocsModel.fromCollection(QuerySnapshot<Map<String, dynamic>> collection) {
//     length = collection.docs.length;
//     for (var snap in collection.docs) {
//       data.add(
//         UserDataModel.fromSnapshot(snap),
//       );
//     }
//   }
//
//   UserDocsModel.fromList(List list) {
//     length = list.length;
//
//     for (Map map in list) {
//       data.add(
//         UserDataModel.fromMap(map),
//       );
//     }
//   }
//
//   List<Map<String, dynamic>> toList() {
//     if (data.isEmpty) return [];
//     return data.map((e) => e.toMap()).toList();
//   }
// }