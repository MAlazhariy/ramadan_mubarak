import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  final int maxCharactersPerLine = 200;


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint("--> ${options.method} ${options.path}");
    debugPrint("Headers: ${options.headers}");
    debugPrint("parameters: ${options.queryParameters}"); // todo: remove
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("<-- [${response.statusCode}] ${response.requestOptions.path}");
    debugPrint("${response.data}".replaceAll('\n', ' '));
    debugPrint("-----");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log("!!! API ERROR [${err.response?.statusCode}] => path: ${err.requestOptions.path}");
    debugPrint("error message: ${err.message}\nresponse: ${err.response}");
    return super.onError(err, handler);
  }
}