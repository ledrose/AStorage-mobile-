import 'package:flutter_application_1/global_things/base.dart';

Future<String?> getToken(String email, String password) async {
  var response = await dioFetch(
    method: "POST",
    data: {"email": email, "password": password},
    dirLink: '/Token',
  );
  if (response.statusCode == 200) {
    return response.data;
  } else {
    return null;
  }
}
