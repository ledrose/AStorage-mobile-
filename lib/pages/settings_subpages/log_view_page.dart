import 'package:flutter/material.dart';

class LogView extends StatelessWidget {
  final String logText;
  final String logName;
  const LogView({required this.logText, required this.logName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(logName),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(logText),
        ),
      ),
    );
  }
}
