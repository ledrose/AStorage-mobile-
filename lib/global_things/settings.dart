import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
GlobalKey appKey = GlobalKey();
enum themeNumber {
  light,
  dark,
}
var currentTheme = ValueNotifier<themeNumber>(themeNumber.light);