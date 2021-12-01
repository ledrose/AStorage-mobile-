import 'dart:typed_data';
import 'package:flutter_application_1/global_things/settings.dart';
import 'package:http/http.dart' as http;
import '../global_things/base.dart';

String url = '$halfLink/Files/';
Map<String, String> headers = {
  "Authorization": curUser.key,
  "accept": "text/plain",
};

Future<Uint8List> getImage(int id) async {
  print("Started sending");
  final response = await http.get(
    Uri.parse(url + id.toString()),
    headers: headers,
  );
  if (response.statusCode == 200) {
    print("Recieved");
    return response.bodyBytes;
  } else {
    throw Exception('Failed to recieve image');
  }
}
