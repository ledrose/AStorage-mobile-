import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import './base.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

final _headers = {
  "Authorization": key,
};

// Future<Question> sendImage(XFile file) async {
//   //Returns "Bad request" response
//   var request = http.MultipartRequest("POST", Uri.parse('$halfLink/Files'));
//   var pic = await http.MultipartFile.fromPath("File", file.path);
//   request.files.add(pic);
//   request.headers.addAll(_headers);
//   var response = await request.send();
//   if (response.statusCode == 200) {
//     print("Recieved");
//     Question? q;
//     await response.stream
//         .bytesToString()
//         .then((value) => q = Question.fromJson(jsonDecode(value)));
//     return q!;
//   } else {
//     print("Failed");
//     throw Exception('Failed to send Image');
//   }
// }

// Future<Question> sendImageBase64(XFile file) async {
//   //Return "internal server error"
//   final response = await http.post(
//     Uri.parse('$halfLink/Files'),
//     headers: _headers,
//     body: {
//       'File': 'data:image/png:base64,' + base64Encode(await file.readAsBytes())
//     },
//   );
//   if (response.statusCode == 200) {
//     print("Recieved");
//     return Question.fromJson(jsonDecode(response.body));
//   } else {
//     print("Failed");
//     throw Exception('Failed to send Image');
//   }
// }

Future<Question> sendImageDio(XFile file) async {
  Dio dio = Dio();
  dio.options.baseUrl = halfLink;
  dio.options.connectTimeout = 30000;
  dio.options.receiveTimeout = 30000;
  dio.options.headers = _headers;
  FormData formData = FormData.fromMap({
    "File": await MultipartFile.fromFile(file.path,
        filename: file.path.split('/').last),
  });
  var response = await dio.post(
    '/Files',
    data: formData,
    options: Options(
      followRedirects: false,
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
    throw Exception('Failed to send Image');
  }
}
