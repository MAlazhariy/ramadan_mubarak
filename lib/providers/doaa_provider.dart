import 'package:flutter/material.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/response_model.dart';
import 'package:ramadan_kareem/data/model/user_model.dart';
import 'package:ramadan_kareem/data/repository/doaa_repo.dart';

class DoaaProvider extends ChangeNotifier {
  final DoaaRepo doaaRepo;

  DoaaProvider(this.doaaRepo);

  List<User> _users = [];
  /// If [true] that means there are no docs other than the docs
  /// that have already been fetched in the application,
  /// and all that data collection has been fetched from the server.
  bool _noMoreDocs = false;

  List<User> get users => _users;

  Future<ResponseModel> getData({int limit = 4, bool pagination = false, bool fromBeginning = false}) async {
    if(_noMoreDocs) return ResponseModel.withSuccess();

    final lastDocTime = pagination && _users.isNotEmpty ? _users.last.timeStamp : null;
    final apiResponse = await doaaRepo.getData(limit: limit, lastDocTime: lastDocTime);

    if(!apiResponse.isSuccess){
      return ResponseModel.withError(apiResponse.error?.message);
    }

    final data = apiResponse.response!.data;

    for(var json in data){
      //todo: check users duplications if needed
      _users.add(
        User.fromJson(json['data'], id: json['id'],)
      );
    }

    if(data.length < limit && !_noMoreDocs){
      final count = await doaaRepo.getDocsCount()??0;
      final isThereMoreData = count > data.length && count != _users.length;

      if(isThereMoreData){
        final remainedLimit = count - limit;
        return getData(limit: remainedLimit, fromBeginning: true);
      } else {
        _updateNoMoreDocs();
      }
    }

    return ResponseModel.withSuccess();
  }

  void _updateNoMoreDocs([bool value = true]){
    _noMoreDocs = value;
  }
}