import 'package:ramadan_kareem/data/model/user_model.dart';
import 'package:ramadan_kareem/helpers/api_data_helper.dart';
import 'package:ramadan_kareem/helpers/enums/user_status_enum.dart';

class UserDetails extends User {
  late final DateTime time;
  late final String? deviceId;
  late final UserStatus status;

  UserDetails({
    required super.id,
    required super.name,
    required super.doaa,
    required this.time,
    required this.deviceId,
    this.status = UserStatus.newMember,
  });

  UserDetails.fromObject(
    UserDetails o,
  ) : super.fromObject(o) {
    deviceId = o.deviceId;
    time = o.time;
    status = o.status;
  }

  UserDetails.fromJson(Map<String, dynamic> json, {required String id}) : super.fromJson(json, id: id) {
    deviceId = json['device_id'];
    time = ApiDataHelper.getDateTimeFromStamp(json['time'])??DateTime.now();
    status = json['status'].toUserStatus;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doaa': doaa,
      'device_id': deviceId,
      'status': status.name,
      'time': time.millisecondsSinceEpoch,
    };
  }
}
