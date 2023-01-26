
// ignore_for_file: empty_catches

import 'package:dio/dio.dart';
import 'package:ramadan_kareem/data/model/base/error_response_model.dart';
import 'package:flutter/material.dart';

/// Handling the error here and return a final result of error and parse to
/// final responseModel.error


class ApiErrorHandler {
  static ErrorResponse handle(dynamic error){
    debugPrint('error handler');
    debugPrint('- error type: ${error.runtimeType}');
    debugPrint('- error: $error');

    if (error is Response) {
      ErrorResponse? errorResponse;
      try {
        errorResponse = ErrorResponse.fromJson(
          error.data,
          code: error.statusCode,
          // message: error.response?.statusMessage,
        );

      } catch(e){}
      debugPrint('--- error data: ${error.data}');
      debugPrint('--- error message: ${error.statusMessage}');

      if (errorResponse == null) {
        return ErrorResponse("${error.statusCode}: ${"error_occurred"}");
      } else {
        return errorResponse;
      }
    } else if (error is! Exception){
      return ErrorResponse("$error");
    }

    try{
      if(error is! DioError){
        return ErrorResponse("$error");
      }

      switch (error.type){
        case DioErrorType.connectTimeout:
          return ErrorResponse("connection_timeout_error");
        case DioErrorType.sendTimeout:
          return ErrorResponse("send_timeout_error");
        case DioErrorType.receiveTimeout:
          return ErrorResponse("receive_timeout_error");
        case DioErrorType.cancel:
          return ErrorResponse("error_request_canceled");
        case DioErrorType.other:
          return ErrorResponse("connection_failed_check_internet");

        case DioErrorType.response:
          switch (error.response!.statusCode){
            case 404:
            case 500:
            case 503:
              return ErrorResponse("${error.response!.statusCode}: ${error.response!.statusMessage??"error_occurred"}");

            default:
              ErrorResponse? errorResponse;
              try {
                errorResponse = ErrorResponse.fromJson(
                  error.response?.data,
                  code: error.response?.statusCode,
                  // message: error.response?.statusMessage,
                );

              } catch(e){}
                debugPrint('--- error data: ${error.response?.data}');
                debugPrint('--- error message: ${error.response?.statusMessage}');

              if (errorResponse == null) {
                return ErrorResponse("${error.response?.statusCode}: ${"error_occurred"}");
              } else {
                return errorResponse;
              }
          }
      }
    } on FormatException catch (e){
      return ErrorResponse("${"error_occurred"}: $e");
    }
  }
}