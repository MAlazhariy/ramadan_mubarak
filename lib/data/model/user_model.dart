import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late final String id;
  late final String name;
  late final String doaa;

  User({
    required this.id,
    required this.name,
    required this.doaa,
});

  User.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    id = snapshot.id;
    name = snapshot.data()['name'];
    doaa = snapshot.data()['doaa'];
  }

  User.fromObject(
    User o,
  ) {
    id = o.id;
    name = o.name;
    doaa = o.doaa;
  }

  User.fromJson(Map<String, dynamic> json, {required String id}) {
    id = id;
    name = json['name'];
    doaa = json['doaa'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doaa': doaa,
    };
  }
}
