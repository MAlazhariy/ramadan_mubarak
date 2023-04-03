import 'package:ramadan_kareem/data/model/user_model.dart';
import 'package:ramadan_kareem/helpers/enums/user_role_enum.dart';
import 'package:ramadan_kareem/helpers/enums/user_status_enum.dart';

class UserDetails extends User {
  late final String? deviceId;
  late final UserStatus status;
  late final UserRole role;
  late final String token;
  late final String nameUpdate;
  late final String doaaUpdate;

  bool get isModerator => role == UserRole.admin || role == UserRole.moderator;
  bool get isAdmin => role == UserRole.admin;

  UserDetails({
    required super.id,
    required super.name,
    required super.doaa,
    required super.time,
    super.isAlive,
    required this.deviceId,
    this.status = UserStatus.newMember,
    this.role = UserRole.user,
    this.token = '',
    this.nameUpdate = '',
    this.doaaUpdate = '',
  });

  UserDetails.fromObject(
    UserDetails o,
  ) : super.fromObject(o) {
    deviceId = o.deviceId;
    status = o.status;
    nameUpdate = o.nameUpdate;
    doaaUpdate = o.doaaUpdate;
  }

  UserDetails.fromJson(Map<String, dynamic> json, {required String id}) : super.fromJson(json, userId: id) {
    deviceId = json['device_id'];
    status = json['status'].toString().toUserStatus();
    role = json['role']?.toString().toUserRole() ?? UserRole.user;
    token = json['token']??'';
    nameUpdate = json['name_update']??'';
    doaaUpdate = json['doaa_update']??'';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      ...super.toJson(),
      'device_id': deviceId,
      'status': status.name,
      'role': role.name,
      'name_update': nameUpdate,
      'doaa_update': doaaUpdate,
      'pending_edit': nameUpdate.isNotEmpty,
    };
  }
}
