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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      DataSaver.initData().whenComplete(() => setState(() {
            DataSaver.loadUser();
            DataSaver.loadAppData();
          }));
    });
    currentTheme = ValueNotifier<int>(0);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentTheme,
      builder: (context, curThemeId, widget) {
        return MaterialApp(
          title: 'AStorage',
          debugShowCheckedModeBanner: false,
          key: appKey,
          theme: themeList.entries.elementAt(curThemeId).value,
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
      label: "Отправка",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.comment),
      label: "Поиск",
    ),
    const BottomNavigationBarItem(
      
      icon: Icon(Icons.settings),
      label: "Настройки",
    ),
  ];

  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AStorage'),
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
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
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
