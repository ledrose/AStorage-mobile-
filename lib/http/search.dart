import 'dart:convert';
import 'package:http/http.dart' as http;
import './base.dart';


String url = "$halfLink/Files/Table";
Map<String,String> headers = {
  "Content-Type": "application/json",
  "Authorization": key,
};

Map<String, dynamic> searchBody() {
  Map<String, dynamic> temp = {
    "draw": 0,
    "start": 0,
    "length": 100,
    "columns": [
      {
        "name": "string",
        "searchable": true,
        "orderable": true,
        "search": {"value": "string", "regex": true}
      }
    ],
    "search": {"value": "string", "regex": true},
    "order": [
      {"column": 0, "dir": "string"},
      {"column": 1, "dir": "answer"}
    ]
  };
  return temp;
}

Future<Album> createSearch() async {
  print("Sending");
  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(searchBody()),
  );
  if (response.statusCode == 200) {
    print("Recieved");
    return Album.fromJson(jsonDecode(response.body));
  } else {
    print("Failed");
    throw Exception('Failed to create Album');
  }
}

