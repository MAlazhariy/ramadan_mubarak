import 'dart:developer';
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


}
