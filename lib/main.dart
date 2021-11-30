import 'package:flutter/material.dart';
import './global_things/settings.dart';
import 'package:flutter_application_1/pages/search_page.dart';
import 'package:flutter_application_1/pages/send_page.dart';
import 'package:flutter_application_1/pages/settings_page.dart';

void main() => runApp(const StartApp());

class StartApp extends StatefulWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  final settingNotifier = ValueNotifier(currentSettings);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettings>(
      valueListenable: settingNotifier,
      builder: (context, curSettings, widget) {
        return MaterialApp(
          // showSemanticsDebugger: true,
          title: 'AStorage',
          theme: currentSettings.currentTheme,
          home: const BaseWidget(),
        );
      },
    );
  }
}

class BaseWidget extends StatefulWidget {
  const BaseWidget({Key? key}) : super(key: key);

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  final _bottomNavigationBar = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Send",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.comment),
      label: "Search",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: "Settings",
    ),
  ];

  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASApp'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: const [
          SendPage(),
          SearchPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBar,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _pageController.animateToPage(
              newIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          });
        },
      ),
    );
  }
}
