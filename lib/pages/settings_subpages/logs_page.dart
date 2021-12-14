import 'package:flutter/material.dart';
import 'package:flutter_application_1/http/logs_http.dart';
import 'package:flutter_application_1/pages/settings_subpages/log_view_page.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  bool _isButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logs")),
      body: buildLogList(),
    );
  }

  Widget buildLogList() {
    return FutureBuilder(
      future: getLogsName(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Card(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Error has occured." + snapshot.error.toString());
            } else {
              return logsList(snapshot.data as List);
            }
          default:
            return Container();
        }
      },
    );
  }

  Widget logsList(List logsName) {
    return Scrollbar(
      interactive: true,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          ...logsName.map((e) => ListTile(
                title: Text(e),
                onTap: (_isButtonPressed)
                    ? null
                    : () async {
                        setState(() {
                          _isButtonPressed = true;
                        });
                        String curLogText = await getLog(e);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LogView(
                                  logText: curLogText,
                                  logName: e,
                                )));
                        setState(() {
                          _isButtonPressed = false;
                        });
                      },
              ))
        ],
      ),
    );
  }
}
