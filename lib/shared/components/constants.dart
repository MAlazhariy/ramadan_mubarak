// enum Gender{
//   MALE, FEMALE,
// }

import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/cache_helper/firebase_funcs.dart';
import 'components/network_check.dart';

List localData = [];

Future<void> getInitData() async {

  if(Cache.isLogin){
    final bool connected = await hasNetwork();

    if (connected) {
      // أنا مش عايز أستريم !
      // streamSnapData = FirebaseFirestore.instance.collection('users').orderBy('time').snapshots();

      List mydata = await getFirebaseData();
      Cache.saveData(mydata);
    }

    localData = Cache.getData();
  }

}