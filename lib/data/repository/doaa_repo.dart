import 'package:ramadan_kareem/data/data_source/remote/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoaaRepo {
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  DoaaRepo({
    required this.sharedPreferences,
    required this.dioClient,
  });
}