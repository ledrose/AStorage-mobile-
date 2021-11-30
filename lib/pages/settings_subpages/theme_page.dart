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
          RadioListTile<themeNumber>(
            title: const Text("Светлая тема"),
            value: themeNumber.light,
            groupValue: currentTheme.value,
            onChanged: (value) => setState(() {
              currentTheme.value = value!;
            }),
          ),
          RadioListTile<themeNumber>(
            title: const Text("Темная тема"),
            value: themeNumber.dark,
            groupValue: currentTheme.value,
            onChanged: (value) => {
              setState(() {
                currentTheme.value = value!;
              })
            },
          ),
        ],
      ),
    );
  }
}
