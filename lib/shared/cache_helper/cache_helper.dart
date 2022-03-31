import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class Cache {
  static Box box = Hive.box('box');

  /// login
  static bool get isLogin {
    return box.get('login', defaultValue: false);
  }

  static void hasLoggedIn([bool value = true]) {
    box.put('login', value);
  }

  static void setUserLoginInfo({
    String name,
    String doaa,
    int time,
  }) {
    final Map info = {
      'name': name,
      'doaa': doaa,
      'time': time,
    };
    box.put('userlogininfo', info);
  }

  static String getUserName(){
    Map info = box.get('userlogininfo', defaultValue: {});
    return info['name'];
  }



  /// counter
  static int getCounter() {
    return box.get('counter', defaultValue: 0);
  }

  static void setCounter(int value) {
    box.put('counter', value);
  }



  /// data
  static void saveData(List data){
    box.put('data', data);
  }

  static List getData(){
    var data = box.get('data', defaultValue: []);
    return data;
  }

  static int getLength() {
    List data = getData();
    return data.length;
  }

  static String getName(int index){
    List data = getData();
    return data[index]['name'];
  }

  static String getDoaa(int index){
    List data = getData();
    return data[index]['doaa'];
  }


}
