import 'package:dio/dio.dart';
import 'package:flutter_application_1/global_things/base.dart';

Future<String?> getToken(String email, String password) async {
  Dio dio = Dio();
  dio.options.baseUrl = halfLink;
  dio.options.connectTimeout = 30000;
  dio.options.receiveTimeout = 30000;
  var response = await dio.post(
    '/Token',
    data: {"email": email, "password": password},
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        if (status == null) return false;
        return status < 500;
      },
      receiveDataWhenStatusError: true,
      method: "POST",
      responseType: ResponseType.json,
    ),
  );
  if (response.statusCode == 200) {
    return response.data;
  }
  else {
    return null;
  }
}
