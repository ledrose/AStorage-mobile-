import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../global_things/base.dart';
import 'package:dio/dio.dart';

Future<Question> sendImageDio(XFile file) async {
  FormData formData = FormData.fromMap({
    "File": await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
      contentType: MediaType("image", file.path.split(".").last),
    ),
  });
  var response = await dioPost(
    data: formData,
    dirLink: '/Files',
    contentType: "multipart/form-data",
    headers: {
      "Authorization": key,
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

Future<void> sendAnswer(int id, String answer) async {
  var response = await dioPost(
    data: null,
    dirLink: '/Files/$id/Answer?answer=$answer',
    headers: {
      "Authorization": key,
    },
  );
  if (response.statusCode != 200) {
    // showTextSnackBar(response.data.toString());
    print(response.data.toString());
  }
}
