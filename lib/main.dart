import 'package:flutter/material.dart';
import 'package:flutter_application_1/route_generator.dart';
import 'http/search.dart';

void main() => runApp(StartApp());

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);
  // void sendpost() async {
  //   Album testAlbum = Album(questions: []);
  //   await createAlbum().then((value) => testAlbum = value);
  //     for (var item in testAlbum.questions) {
  //       print(item.fileName);
  //       for (var j in item.answers) {
  //         print(j.answer);
  //       }
  //     }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showSemanticsDebugger: true,
      title: 'AsApp',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
