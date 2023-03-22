import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ramadan_kareem/helpers/api_data_helper.dart';

class User {
  late final String id;
  late final String name;
  late final String doaa;
  late final DateTime time;
  late final bool isAlive;

  int get timeStamp => time.millisecondsSinceEpoch.abs();

  User({
    required this.id,
    required this.name,
    required this.doaa,
    required this.time,
    this.isAlive = true,
});

  User.fromObject(
    User o,
  ) {
    id = o.id;
    name = o.name;
    doaa = o.doaa;
    time = o.time;
  }

  User.fromJson(Map<String, dynamic> json, {required String userId}) {
    id = userId;
    name = json['name'];
    doaa = json['doaa'];
    time = ApiDataHelper.getDateTimeFromStamp(json['time'])??DateTime.now();
    isAlive = json['is_alive'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doaa': doaa,
      'time': timeStamp,
      'is_alive': isAlive,
    };
  }
}
