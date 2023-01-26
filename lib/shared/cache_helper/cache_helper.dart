import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';

class Cache {
  static Box box = Hive.box('box');

  /// login
  static bool isLogin() {
    return box.get('login', defaultValue: false);
  }

  static void hasLoggedIn([bool value = true]) {
    box.put('login', value);
  }

  static void setUserLoginInfo({
    required String name,
    required String doaa,
    required int time,
    required String? docId,
  }) {
    final Map info = {
      'name': name,
      'doaa': doaa,
      'time': time,
      'docId': docId,
    };
    box.put('userlogininfo', info);
  }

  static String getUserName(){
    Map info = box.get('userlogininfo', defaultValue: '');
    return info['name'];
  }

  static int getUserLoginTime(){
    Map info = box.get('userlogininfo', defaultValue: 0);
    return info['time'];
  }

  static void loginHasChecked([bool value = true]){
    box.put('loginCheck', value);
  }

  static bool isLoginChecked(){
    return box.get('loginCheck', defaultValue: false);
  }

  /// set if it is the first time that user using the app
  static void setIsFirstTime([bool value = false]){
    box.put('firstTime', value);
  }

  static bool isFirstTime(){
    return box.get('firstTime', defaultValue: true);
  }



  /// counter
  static int getCounter() {
    return box.get('counter', defaultValue: 0);
  }

  static void setCounter(int value) {
    box.put('counter', value);
  }



  /// data
  // static void saveUserData(List userModel){
  //   box.put('userModel', userModel);
  // }
  //
  // static List getUserData(){
  //   var data = box.get('userModel');
  //   return data;
  // }

  static void saveData(List data){
    box.put('data', data);
  }

  static List getData(){
    var data = box.get('data', defaultValue: []);
    return data;
  }

  static int? getLength() {
    return userModel?.data.where((user) => user.approved == true).toList().length;
  }



  /// notifications
  static void notificationsDone([value = true]){
    box.put('notifications', value);
  }

  static bool isNotificationsDone(){
    return box.get('notifications', defaultValue: false);
  }



  /// location coordinates
  static bool isCoordinatesSaved(){
    return box.get('coordinates_saved', defaultValue: false);
  }

  static void _coordinatesHasSaved([bool value = true]){
    box.put('coordinates_saved', value);
  }

  static void setCoordinates(double latitude, double longitude){
    _coordinatesHasSaved();
    box.put('coordinates', [latitude, longitude]);
  }

  static List<double> getCoordinates(){
    return box.get('coordinates',);
  }

  static double getLatitude(){
    var list = getCoordinates();
    return list[0];
  }

  static double getLongitude(){
    var list = getCoordinates();
    return list[1];
  }


}
