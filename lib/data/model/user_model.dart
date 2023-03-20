import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late final String id;
  late final String name;
  late final String doaa;
  late final bool isAlive;

  User({
    required this.id,
    required this.name,
    required this.doaa,
    this.isAlive = true,
});

  User.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    id = snapshot.id;
    name = snapshot.data()['name'];
    doaa = snapshot.data()['doaa'];
    isAlive = snapshot.data()['is_alive'];
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
    isAlive = json['is_alive'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doaa': doaa,
      'is_alive': isAlive,
    };
  }
}
