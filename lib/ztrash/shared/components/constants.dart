import 'dart:developer' as dev;
import 'dart:math';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/helpers/network_check.dart';
import 'package:ramadan_kareem/ztrash/shared/cache_helper/cache_helper.dart';


String? deviceId;
UserDetails? userModel;

Future<void> initGetAndSaveData() async {
  final bool connected = await hasNetwork();

  /// check id
  if (!CacheHelper.isLoginChecked() && connected) {
    dev.log('started search for id');

    if (deviceId != null && (deviceId?.isNotEmpty??false)) {
      // search by device id
      var users = [];
      if (users.isNotEmpty??false) {
        CacheHelper.setUserLoginInfo(
          name: users.first.name,
          doaa: users.first.doaa,
          time: users.first.time,
          docId: users.first.deviceId,
        );
        dev.log('$deviceId logged in before 👍');
      }
    }
    dev.log('checked');
    CacheHelper.loginHasChecked();
  }
}

int getRandomIndex() {
  // todo: check getRandomIndex
  try {
    return Random().nextInt(CacheHelper.getLength()!);
  } catch (e) {
    return 0;
  }
}
