import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/global_things/settings.dart';
import '../global_things/base.dart';

Future<Uint8List> getImage(int id) async {
  final response = await dioFetch(
    dirLink: '/Files/$id',
    method: "GET",
    headers: {
      "Authorization": curUser.key,
    },
    responseType: ResponseType.bytes,
  );
  if (response.statusCode == 200) {
    return response.data as Uint8List;
  } else {
    throw Exception('Failed to recieve image');
  }
}
