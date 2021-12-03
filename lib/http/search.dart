import 'dart:convert';
import 'package:flutter_application_1/global_things/settings.dart';
import '../global_things/base.dart';

Future<int?> deleteQuestion(int id) async {
  var response = await dioFetch(
    dirLink: "/Files/$id",
    method: "DELETE",
    headers: {"Authorization": curUser.key},
  );
  return response.statusCode;
}

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

Map<String, dynamic> searchBody(List<List<String>> sort,int startIndex,int? batchSize) {
  return {
    "draw": 0,
    "start": startIndex,
    "length": batchSize,
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

Future<Album> createSearch(int startIndex,int batchSize ,{String searchText = ""}) async {
  print("Sending");
  var response = await dioFetch(
    method: "POST",
    data: jsonEncode(searchBody(formatSearch(searchText),startIndex,batchSize)),
    dirLink: '/Files/Table',
    headers: {
      "Authorization": curUser.key,
    },
  );
  if (response.statusCode == 200) {
    print("Recieved");
    return Album.fromJson(response.data,startIndex,batchSize);
  } else {
    print("Failed");
    throw Exception('Failed to create Album');
  }
}
