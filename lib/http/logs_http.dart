import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_application_1/global_things/settings.dart';
import '../global_things/base.dart';

Future<List> getLogsName() async {
  var response = await dioFetch(
    dirLink: '/Logs',
    method: "GET",
    headers: {
      "Authorization": curUser.key,
    },
  );
  if (response.statusCode == 200) {
    return response.data as List;
  } else {
    return ["Error"];
  }
}

Future<String> getLog(String logName) async {
  Dio dio = standartDio(
    headers: {
      "Authorization": curUser.key,
    },
  );
  try {
    String tempDir = (await getTemporaryDirectory()).path + '/$logName';
    // ignore: unused_local_variable
    var response = await dio.download(
      '/Logs/$logName',
      tempDir,
      options: Options(responseType: ResponseType.stream),
    );
    File file = File(tempDir);
    return file.readAsStringSync();
  } catch (e) {
    return e.toString();
  }
}
