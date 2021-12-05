import 'package:flutter_application_1/global_things/settings.dart';
import '../global_things/base.dart';

Future<List<String>> getLogsName() async {
  var response = await dioFetch(
    dirLink: '/Logs',
    method: "GET",
    headers: {
      "Authorization": curUser.key,
    },
  );
  if (response.statusCode == 200) {
    return response.data as List<String>;
  } else {
    return ["Error"];
  }
}

// Future<void> getLog(String logName) async {
//   var response = await dioFetch(
//     dirLink: "/Logs/$logName",
//     method: "GET",
//     headers: {
//       "Authorization": curUser.key,
//     },
//     responseType: ResponseType.stream,
//   );
//   if (response.statusCode==200) {
//     return 
//   }
// }
