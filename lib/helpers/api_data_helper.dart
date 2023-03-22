class ApiDataHelper {
  static int? getInt(i) {
    switch (i.runtimeType) {
      case String:
        return double.parse('$i').toInt();

      case int:
        return i;
    }

    return null;
  }

  static bool? getBool(i) {
    switch (i.runtimeType) {
      case String:
        return i == '1' || i == 'true';

      case int:
        return i == 1;

      case bool:
        return i;
    }

    return null;
  }

  static DateTime? getDateTimeFromStamp(i) {
    final timeStamp = getInt(i);
    return timeStamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timeStamp)
        : null;
  }
}
