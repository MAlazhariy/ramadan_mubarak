
/// final response model comes from provider to the screen
class ResponseModel {
  final bool _isSuccess;
  final String? _message;
  final int? _code;

  String? get message => _message;
  bool get isSuccess => _isSuccess;
  int? get code => _code;

  ResponseModel.withSuccess([String? message, int? code])
      : _message = message,
        _isSuccess = true,
        _code = code;

  ResponseModel.withError([String? message, int? code])
      : _message = message,
        _isSuccess = false,
        _code = code;
}
