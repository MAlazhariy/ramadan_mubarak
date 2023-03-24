import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/response_model.dart';
import 'package:ramadan_kareem/data/model/user_model.dart';
import 'package:ramadan_kareem/data/repository/auth_repo.dart';
import 'package:ramadan_kareem/data/repository/doaa_repo.dart';
import 'package:ramadan_kareem/data/repository/profile_repo.dart';
import 'package:ramadan_kareem/utils/di_container.dart';

class DoaaProvider extends ChangeNotifier {
  final DoaaRepo doaaRepo;

  DoaaProvider(this.doaaRepo);

  List<User> _users = [];

  /// If [true] that means there are no docs other than the docs
  /// that have already been fetched in the application,
  /// and all that data collection has been fetched from the server.
  bool _noMoreDocs = false;
  bool _isLoading = false;
  int _lastIndex = 0;
  double _cachedPosition = 0;

  List<User> get users => _users;

  bool get isLoading => _isLoading;

  int get lastIndex => _lastIndex;

  double get cachedPosition => _cachedPosition;

  Future<ResponseModel> paginate(
    int index, {
    required double position,
    int gap = 2,
  }) async {
    // update the current time
    debugPrint('updating time..');
    _lastIndex = index;
    _cachedPosition = position;
    await updateLastDocTime(_users[index].timeStamp);
    debugPrint('time updated');

    final isReadyGetData = index >= _users.length - 1 - gap && !_isLoading;
    debugPrint('is ready to get paginated data: "$isReadyGetData"');
    // TODO: SOLVE THIS ISSUE - THE PAGINATION NOT WORKING WELL SPECIALLY AFTER RECONNECT TO THE INTERNET
    if (isReadyGetData) {
      return getData(pagination: true);
    }
    return ResponseModel.withSuccess();
  }

  Future<bool> updateLastDocTime(int timeStamp) async {
    return await doaaRepo.updateLastDocTime(timeStamp);
  }

  Future<ResponseModel> getData({
    int limit = 4,
    bool pagination = false,
    bool fromBeginning = false,
  }) async {
    debugPrint('==============');
    debugPrint('start getData');
    if (_noMoreDocs) {
      debugPrint('no more docs - end getting data');
      return ResponseModel.withSuccess();
    } else if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    final lastDocTime = pagination && _users.isNotEmpty ? _users.last.timeStamp : null;
    debugPrint('last doc time: $lastDocTime');

    final apiResponse = await doaaRepo.getData(
      limit: limit,
      lastDocTime: lastDocTime,
      fromBeginning: fromBeginning,
    );
    late ResponseModel responseModel;

    if (!apiResponse.isSuccess) {
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    } else {
      final List<Map<String, dynamic>> data = apiResponse.response!.data;

      for (var json in data) {
        //todo: check users duplications if needed
        _users.add(User.fromJson(
          json['data'],
          userId: json['id'],
        ));
      }

      debugPrint('data has got successfully');

      if (data.length < limit && !_noMoreDocs) {
        debugPrint('data length "${data.length}" not equals the limit "$limit"');
        final count = await doaaRepo.getDocsCount() ?? 0;
        final isThereMoreData = count > data.length && count != _users.length;
        debugPrint('is there more data in server to get? $isThereMoreData');

        if (isThereMoreData) {
          debugPrint('get more data');
          final remainedLimit = limit - data.length;
          debugPrint('start get remained limit: $remainedLimit');
          return getData(limit: remainedLimit, fromBeginning: true);
        } else {
          debugPrint('updating no more docs');
          _updateNoMoreDocs();
        }
      }
      responseModel = ResponseModel.withSuccess();
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  /// insert the new user to the top of users
  /// to show in the home screen
  void insertTheNewUser() {
    final profileRepo = Di.sl<ProfileRepo>();
    final user = profileRepo.getLocalUserDetails();
    if(user ==null){
      return;
    }
    debugPrint('user added successfully to the users list');
    debugPrint('user: ${user.toJson()}');
    _users.insert(0, user);
    notifyListeners();
  }

  void _updateNoMoreDocs([bool value = true]) {
    _noMoreDocs = value;
  }
}
