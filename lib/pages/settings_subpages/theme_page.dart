import 'package:flutter/material.dart';
import 'package:flutter_application_1/global_things/settings.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Выберите тему"),
      ),
      body: ListView(
        children: [
          ...themeList.entries.map(
            (e) => RadioListTile<int>(
              title: Text(e.key),
              value: themeList.keys.toList().indexWhere((el) => el==e.key),
              groupValue: currentTheme.value,
              onChanged: (value) => setState(
                () {
                  currentTheme.value = value!;
                  DataSaver.saveTheme();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
