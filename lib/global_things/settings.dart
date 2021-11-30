import 'package:flutter/foundation.dart';

enum themeNumber {
  light,
  dark,
}
var  currentTheme = ValueNotifier<themeNumber>(themeNumber.light);
