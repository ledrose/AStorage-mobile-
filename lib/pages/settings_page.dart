import 'package:flutter/material.dart';
import 'package:flutter_application_1/global_things/settings.dart';
import 'package:flutter_application_1/pages/settings_subpages/auth_page.dart';

import 'settings_subpages/logs_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Card(
          child: ExpansionTile(
            title: Text("Аунтефикация"),
            children: [
              AuthPage(),
            ],
          ),
        ),
        Card(
          child: ListTile(
            title: const Text("Тема"),
            trailing: DropdownButton(
                value: currentTheme.value,
                onChanged: (int? newValue) => setState(() {
                      currentTheme.value = newValue!;
                      DataSaver.saveTheme();
                    }),
                items: themeList.keys
                    .map<DropdownMenuItem<int>>(
                        (value) => DropdownMenuItem<int>(
                              value: themeList.keys
                                  .toList()
                                  .indexWhere((element) => element == value),
                              child: Text(value),
                            ))
                    .toList()),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text("Количество вопросов на странице"),
            trailing: DropdownButton(
                value: batchSize,
                onChanged: (int? newValue) => setState(() {
                      batchSize = newValue!;
                      DataSaver.saveBatchSize();
                    }),
                items: List.generate(10, (index) => index + 1)
                    .map<DropdownMenuItem<int>>(
                        (value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            ))
                    .toList()),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text("Логи"),
            onTap: () {
              if (curUser.permissions.contains("GetLogs")) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LogsPage()));
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("У вас нету прав на эту операцию")));
              }
            },
          ),
        )
      ],
    );
  }
}
