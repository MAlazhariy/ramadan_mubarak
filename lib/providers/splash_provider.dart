
import 'dart:math';

import 'package:ramadan_kareem/data/model/base/response_model.dart';
import 'package:ramadan_kareem/data/repository/splash_repo.dart';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;

  SplashProvider(this.splashRepo);

  bool _isLoading = false;
  String _hadeeth = '';


  bool get isFirstOpen => splashRepo.isFirstOpen();
  bool get isLoading => _isLoading;
  String get hadeeth => _hadeeth;

  Future<ResponseModel> initAppData() async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await splashRepo.initAppData();

    _isLoading = false;
    notifyListeners();

    return apiResponse.isSuccess
        ? ResponseModel.withSuccess()
        : ResponseModel.withError(apiResponse.error?.toString());
  }

  Future<bool> setIsAppFirstOpen() async {
    return await splashRepo.setIsAppFirstOpen();
  }

  Future<void> getRandomHadeeth () async {
    final response = await splashRepo.getSplashAhadeeth();
    final List ahadeeth = response['data'];
    final randomNum = Random().nextInt(ahadeeth.length);
    _hadeeth = ahadeeth[randomNum];

    notifyListeners();
  }
}