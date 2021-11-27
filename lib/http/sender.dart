import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './base.dart';
import 'package:dio/dio.dart';

Future<Question> sendImageDio(XFile file) async {
  Dio dio = Dio();
  dio.options.baseUrl = halfLink;
  dio.options.connectTimeout = 30000;
  dio.options.receiveTimeout = 30000;
  dio.options.headers = {
    "Authorization": key,
  };
  FormData formData = FormData.fromMap({
    "File": await MultipartFile.fromFile(file.path,
        filename: file.path.split('/').last),
  });
  var response = await dio.post(
    '/Files',
    data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        if (status == null) return false;
        return status < 500;
      },
      contentType: "multipart/form-data",
      receiveDataWhenStatusError: true,
      method: "POST",
      responseType: ResponseType.json,
    ),
  );
  if (response.statusCode == 200) {
    print("Recieved");
    return Question.fromJson(jsonDecode(response.data));
  } else {
    print("Failed");
    return Question.error("Ошибка:" + response.data.toString());
  }
}

Future<void> sendAnswer(int id,String answer) async {
  Dio dio = Dio();
  dio.options.baseUrl = halfLink;
  dio.options.connectTimeout = 30000;
  dio.options.receiveTimeout = 30000;
  dio.options.headers = {
    "Authorization": key,
  };
  var response = await dio.post(
    '/Files/${id}/Answer?answer=${answer}',
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
  if (response.statusCode!=200) {
    print(response.data.toString());
  }
}
