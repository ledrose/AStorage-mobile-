import 'dart:typed_data';
import 'package:dio/dio.dart';

String version = '1.0';
String baseUrl = "https://bfs-astorage.somee.com";
String key =
    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3YjhiMDVhYy0yMDE5LTQ3MDQtYTA1My0wNDM0OTE4YWQzZDAiLCJpYXQiOjE2MzgyODgyNjcsIkNyZWF0aW9uRGF0ZXRpbWUiOiIxMS8zMC8yMDIxIDExOjA0OjI3IFBNIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6ImFkbWluQG1haWwucnUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhZG1pbkBtYWlsLnJ1Iiwic3ViIjoiMSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiMSIsInNlY3VyaXR5U3RhbXAiOiJFM0FDNzQ3R0xWNFlVVzJOUUNBTE0zMlFIWDREVVAzUSIsIkV4cGlyZXNJbiI6IjEwMDAwIiwiQ3JlYXRlUm9sZXMiOiIxIiwiRGVsZXRlRmlsZXMiOiIyIiwiR2V0TG9ncyI6IjIwMCIsIkRlbGV0ZVJvbGVzIjoiMyIsIlB1dEZpbGVzIjoiNCIsIkdldFJvbGVzIjoiNSIsIkVkaXRVc2VycyI6IjYiLCJHZXRVc2VycyI6IjciLCJBZGRVc2VycyI6IjgiLCJBZGRVc2VyVG9Sb2xlIjoiOSIsIlNlbmRFbWFpbCI6IjEwIiwibmJmIjoxNjM4Mjg4MjY3LCJleHAiOjE2NzQyODgyNjcsImlzcyI6Imh0dHBzOi8vYmZzLWFzdG9yYWdlLnNvbWVlLmNvbS8iLCJhdWQiOiJBU3RvcmFnZV9hcGkifQ.O96z5wyNiEFGHpA3SjTHa1MMNRazk8n9IpOHF5_iT_8";
String halfLink = '$baseUrl/api/v$version';

Future<Response<dynamic>> dioPost({
  required dynamic data,
  required String dirLink,
  int timeout = 10000,
  Map<String, dynamic>? headers,
  String contentType = "application/json",
}) async {
  Dio dio = Dio();
  dio.options.baseUrl = halfLink;
  dio.options.connectTimeout = timeout;
  dio.options.receiveTimeout = timeout;
  dio.options.headers = headers;
  return await dio.post(
    dirLink,
    data: data,
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        if (status == null) return false;
        return status < 500;
      },
      contentType: contentType,
      receiveDataWhenStatusError: true,
      method: "POST",
      responseType: ResponseType.json,
    ),
  );
}

class Album {
  final List<Question> questions;
  Album({required this.questions});

  factory Album.fromJson(Map<String, dynamic> json) {
    List<Question> tQuestions = [];
    for (var item in (json['data'] as List<dynamic>)) {
      tQuestions.add(Question.fromJson(item));
    }
    return Album(
      questions: tQuestions,
    );
  }
}

class Question {
  final int id;
  final String fileName;
  Uint8List? fileBytes;
  String? imgText;
  final List<Answer> answers;
  String? error;
  Question(
      {required this.id,
      required this.fileName,
      required this.answers,
      this.imgText,
      this.error});

  factory Question.fromJson(Map<dynamic, dynamic> json) {
    List<Answer> tAnswers = [];
    for (var item in (json['averageAnswers'] as List<dynamic>)) {
      tAnswers.add(Answer.fromJson(item));
    }
    if (json['text'].toString().isNotEmpty) {
      return Question(
          id: json['id'],
          fileName: json['fileName'],
          answers: tAnswers,
          imgText: json['text']);
    } else {
      return Question(
          id: json['id'], fileName: json['fileName'], answers: tAnswers);
    }
  }
  factory Question.error(String errorText) {
    return Question(answers: [], id: -1, fileName: '', error: errorText);
  }
}

class Answer {
  final String answer;
  final double percent;
  final int count;
  Answer({required this.answer, required this.percent, required this.count});

  factory Answer.fromJson(Map<dynamic, dynamic> json) {
    return Answer(
      answer: json['answer'],
      percent: json['percent'],
      count: json['count'],
    );
  }
}
