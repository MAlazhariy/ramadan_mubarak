import 'dart:developer' as dev;
import 'dart:math';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/ztrash/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/ztrash/users_model.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/network/firebase_funcs.dart';
import 'package:ramadan_kareem/view/widgets/snack_bar.dart';
import '../../helpers/network_check.dart';

String? deviceId;
UserDocsModel? userModel;

Future<void> initGetAndSaveData() async {
  final bool connected = await hasNetwork();

  if (connected) {
    // get data from Firebase
    await getCollection().then((data) {
      userModel = UserDocsModel.fromCollection(data);
    }).catchError((error) {
      userModel = UserDocsModel.fromList(
        Cache.getData(),
      );
    });
  } else {
    // get data from local
    userModel = UserDocsModel.fromList(Cache.getData());
  }

  // save data to local
  if(userModel != null) {
    Cache.saveData(userModel!.toList());
  }

  /// check id
  if (!Cache.isLoginChecked() && connected) {
    dev.log('started search for id');

    if (deviceId != null && (deviceId?.isNotEmpty??false)) {
      // search by device id
      var users = userModel?.data.where((user) => user.deviceId == deviceId);
      if (users?.isNotEmpty??false) {
        Cache.setUserLoginInfo(
          name: users!.first.name,
          doaa: users.first.doaa,
          time: users.first.time,
          docId: users.first.deviceId,
        );
        Cache.hasLoggedIn();
        dev.log('$deviceId logged in before 👍');
      }
    }
    dev.log('checked');
    Cache.loginHasChecked();
  }
}

int getRandomIndex() {
  // todo: check getRandomIndex
  try {
    return Random().nextInt(Cache.getLength()!);
  } catch (e) {
    return 0;
  }
}
