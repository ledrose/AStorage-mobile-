import 'package:flutter/material.dart';
class AppSettings {
  ThemeData currentTheme;
  AppSettings({required this.currentTheme});
}
AppSettings currentSettings = AppSettings(currentTheme: ThemeData.light());