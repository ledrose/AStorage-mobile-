import 'dart:convert';
import 'package:flutter_application_1/global_things/settings.dart';
import '../global_things/base.dart';


List<List<String>> formatSearch(String text) {
  const defaultSearch = ["string", "string"];
  if (text.trim().isEmpty) {
    return [defaultSearch];
  } else {
    var temp = text
        .trim()
        .split("&&")
        .map((e) => e.trim().split("::").toList())
        .toList();
    if ((temp.length == 1) & (temp[0].length == 1)) {
      return [
        ["text", temp[0][0]]
      ];
    } else {
      return temp;
    }
  }
}

Map<String, dynamic> searchBody(List<List<String>> sort) {
  return {
    "draw": 0,
    "start": 0,
    "length": 10,
    "columns": [
      ...sort.map((e) => {
            "name": e[0],
            "searchable": true,
            "orderable": true,
            "search": {"value": e[1], "regex": true}
          })
    ],
    "search": {"value": "string", "regex": true},
    "order": [
      {"column": 0, "dir": "string"}
    ]
  };
}

Future<Album> createSearch({String searchText = ""}) async {
  print("Sending");
  var response = await dioFetch(
    method: "POST",
    data: jsonEncode(searchBody(formatSearch(searchText))),
    dirLink: '/Files/Table',
    headers: {
      "Authorization": curUser.key,
    },
  );
  // final response = await http.post(
  //   Uri.parse(url),
  //   headers: headers,
  //   body: jsonEncode(searchBody(formatSearch(searchText))),
  // );
  if (response.statusCode == 200) {
    print("Recieved");
    return Album.fromJson(response.data);
  } else {
    print("Failed");
    throw Exception('Failed to create Album');
  }
}
