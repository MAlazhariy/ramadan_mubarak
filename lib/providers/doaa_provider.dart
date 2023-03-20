import 'package:flutter/cupertino.dart';
import 'package:ramadan_kareem/data/repository/doaa_repo.dart';

class DoaaProvider extends ChangeNotifier {
  final DoaaRepo doaaRepo;

  DoaaProvider(this.doaaRepo);

  final _maxDoaaLength = 200;
  int _doaaLength = 0;
  _Field? _field;

  int get maxDoaaLength => _maxDoaaLength;

  int get doaaLength => _doaaLength;
  bool get isInNameField => _field == _Field.name;
  bool get isInDoaaField => _field == _Field.doaa;

  void onChangeDoaaLength(int length){
    if(!isInDoaaField){
      onTapField(isName: false);
    }
    _doaaLength = length;
    notifyListeners();
  }

  void onTapField({required bool isName}){
    _field = isName ? _Field.name : _Field.doaa;
    notifyListeners();
  }
}

enum _Field {
  name,
  doaa,
}