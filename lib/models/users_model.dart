import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

// void hi() {
//   FirebaseFirestore.instance.collection('users').orderBy('time').get().then((
//       value) {
//     QuerySnapshot<Map<String, dynamic>> data = value;
//     value.docs
//
//     log(data.docs.length.toString());
//     for (var data in data.docs) {
//       log(data.data()['name']);
//       data.id;
//     }
//   });
// }

class UserDocsModel {
  int length = 0;
  List<UserDataModel> data = [];

  UserDocsModel.fromCollection(QuerySnapshot<Map<String, dynamic>> collection) {
    length = collection.docs.length;
    for (var snap in collection.docs) {
      data.add(
        UserDataModel.fromSnapshot(snap),
      );
    }
  }

  UserDocsModel.fromList(List list) {
    length = list.length;

    for (Map map in list) {
      data.add(
        UserDataModel.fromMap(map),
      );
    }
  }

  List<Map<String, dynamic>> toList(){
    if(data.isEmpty) return [];
    return data.map((e) => e.toMap()).toList();
  }
}

class UserDataModel {
  //   'name': name,
  //   'doaa': doaa,
  //   'device id': id,
  //   'approved': false,
  //   'time': time,
  //   'nameUpdate': '',
  //   'doaaUpdate': '',
  //   'pendingEdit': false,

  String id;

  String name;
  String doaa;
  String deviceId;
  bool approved;
  int time;

  String nameUpdate;
  String doaaUpdate;
  bool pendingEdit;

  UserDataModel.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    id = snapshot.id;

    name = snapshot.data()['name'];
    doaa = snapshot.data()['doaa'];
    deviceId = snapshot.data()['device id'];
    approved = snapshot.data()['approved'];
    time = snapshot.data()['time'];

    nameUpdate = snapshot.data()['nameUpdate'];
    doaaUpdate = snapshot.data()['doaaUpdate'];
    pendingEdit = snapshot.data()['pendingEdit'];
  }

  UserDataModel.fromMap(Map map) {
    id = '';

    name = map['name'];
    doaa = map['doaa'];
    deviceId = map['device id'];
    approved = map['approved'];
    time = map['time'];

    nameUpdate = map['nameUpdate'];
    doaaUpdate = map['doaaUpdate'];
    pendingEdit = map['pendingEdit'];
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'doaa': doaa,
      'device id': deviceId,
      'approved': approved,
      'time': time,
      'nameUpdate': nameUpdate,
      'doaaUpdate': doaaUpdate,
      'pendingEdit': pendingEdit,
    };
  }
}
