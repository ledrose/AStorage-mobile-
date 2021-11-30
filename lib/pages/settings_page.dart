import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/settings_subpages/auth_page.dart';
import 'package:flutter_application_1/pages/settings_subpages/theme_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const settingsPageList = [
    {"name": "Тема", "link": ThemePage()},
    {"name": "Аунтефикация", "link": AuthPage()},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: settingsPageList.length,
      itemBuilder: (context, index) {
        var el = settingsPageList[index];
        return Card(
          child: ListTile(
            title: Text(el["name"] as String),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => (el["link"] as Widget),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
