import 'package:flutter/material.dart';
import 'package:flutter_application_1/searchPage.dart';
import 'package:flutter_application_1/sendPage.dart';
import 'package:flutter_application_1/settingPage.dart';

void main() => runApp(StartApp());

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showSemanticsDebugger: true,
      title: 'AsApp',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: BaseWidget(),
      // initialRoute: '/',
      // onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class BaseWidget extends StatefulWidget {
  BaseWidget({Key? key}) : super(key: key);

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  final _bottomNavigationBar = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Send",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.comment),
      label: "Search",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: "Settings",
    ),
  ];

  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ASApp'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: [
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
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          });
        },
      ),
    );
  }
}
