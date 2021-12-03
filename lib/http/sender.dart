import 'package:flutter_application_1/global_things/settings.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../global_things/base.dart';
import 'package:dio/dio.dart';

Future<Question> sendImageDio(XFile file) async {
  FormData formData = FormData.fromMap(
    {
      "File": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType(
          "image",
          // file.path.split(".").last
          (file.path.split(".").last == "jpg")
              ? "jpeg"
              : file.path.split(".").last,
        ),
      ),
    },
  );
  var response = await dioFetch(
    method: "POST",
    data: formData,
    dirLink: '/Files',
    contentType: "multipart/form-data",
    headers: {
      "Authorization": curUser.key,
    },
  );
  if (response.statusCode == 200) {
    print("Recieved");
    return Question.fromJson(response.data);
  } else {
    print("Failed");
    return Question.error("Ошибка:" + response.data.toString());
  }
}

Future<String> sendAnswer(int id, String answer) async {
  var response = await dioFetch(
    method: "POST",
    data: null,
    dirLink: '/Files/$id/Answer?answer=$answer',
    headers: {
      "Authorization": curUser.key,
    },
    responseType: ResponseType.json,
  );
  if (response.data=="") {
    return "Ответ отправлен";
  }
  return response.data.toString();
}
