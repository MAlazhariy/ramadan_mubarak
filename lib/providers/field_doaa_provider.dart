import 'package:flutter/cupertino.dart';

class FieldDoaaProvider extends ChangeNotifier {
  final _maxDoaaLength = 200;
  int _doaaLength = 0;
  _Field? _loginField;

  int get maxDoaaLength => _maxDoaaLength;

  int get doaaLength => _doaaLength;

  bool get isInNameField => _loginField == _Field.name;

  bool get isInDoaaField => _loginField == _Field.doaa;

  void onChangeDoaaLength(int length) {
    if (!isInDoaaField) {
      onTapField(isName: false);
    }
    _doaaLength = length;
    notifyListeners();
  }

  void onTapField({required bool isName}) {
    _loginField = isName ? _Field.name : _Field.doaa;
    notifyListeners();
  }

  void clear() {
    _doaaLength = 0;
    _loginField = null;
  }

  void initDoaaLength(String doaa){
    _doaaLength = doaa.length;
  }
}

enum _Field {
  name,
  doaa,
}
