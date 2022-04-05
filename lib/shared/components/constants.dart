// enum Gender{
//   MALE, FEMALE,
// }

import 'dart:math';

import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/cache_helper/firebase_funcs.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'components/network_check.dart';

List localData = [];

Future<void> initGetAndSaveData() async {

  final bool connected = await hasNetwork();

  if (connected) {
    List mydata = await getFirebaseData();
    Cache.saveData(mydata);
  }

  // get data from local
  localData = Cache.getData();

}


int getRandomIndex(){
  try{
    return Random().nextInt(Cache.getLength());
  } catch(e){
    return 0;
  }

}