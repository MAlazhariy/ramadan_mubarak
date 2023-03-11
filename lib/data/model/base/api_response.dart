import 'package:dio/dio.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/error_response_model.dart';

class ApiResponse {
  final Response? _response;
  final ErrorResponse? _error;

  Response? get response => _response;
  ErrorResponse? get error => _error;
  bool get isSuccess => _error == null;

  ApiResponse.withSuccess([Response? responseValue])
      : _response = responseValue,
        _error = null;

  ApiResponse.withError(ErrorResponse errorValue)
      : _response = null,
        _error = errorValue;

  ApiResponse.fromResponse(Response response)
      : _response = response.statusCode == 200 && response.data['status'] == true ? response : null,
        _error = response.statusCode == 200 && response.data['status'] == true ? null : ApiErrorHandler.handle(response.data['message']??response.statusMessage);
}
