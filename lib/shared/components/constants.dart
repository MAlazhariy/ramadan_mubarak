// enum Gender{
//   MALE, FEMALE,
// }

import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/cache_helper/firebase_funcs.dart';
import 'components/network_check.dart';

List localData = [];

Future<void> getInitData() async {
  final bool connected = await hasNetwork();

  if(Cache.isLogin) {
    if (connected) {
      List mydata = await getFirebaseData();
      Cache.saveData(mydata);
    }

  } else {
    /// this is the first time using the application
    if(connected){
      List mydata = await getFirebaseData();
      Cache.saveData(mydata);
    }
  }

  // get data from local
  localData = Cache.getData();

}