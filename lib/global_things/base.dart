import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

String version = '1.0';
String baseUrl = "https://bfs-astorage.somee.com";
String halfLink = '$baseUrl/api/v$version';

void showTextSnackBar(BuildContext context, String s) {
  var snackBar = SnackBar(
    content: Text(s),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Dio standartDio({
  int timeout = 10000,
  Map<String, dynamic>? headers,
}) {
  Dio dio = Dio();
  dio.options.baseUrl = halfLink;
  dio.options.connectTimeout = timeout;
  dio.options.receiveTimeout = timeout;
  dio.options.headers = headers;
  return dio;
}

Future<Response<dynamic>> dioFetch({
  dynamic data,
  required String dirLink,
  int timeout = 10000,
  Map<String, dynamic>? headers,
  String contentType = "application/json",
  required String method,
  ResponseType responseType = ResponseType.json,
}) async {
  Dio dio = standartDio(timeout: timeout,headers: headers);
  return await dio.fetch(
    RequestOptions(
      path: halfLink + dirLink,
      data: data,
      followRedirects: false,
      validateStatus: (status) {
        if (status == null) return false;
        return status < 600;
      },
      headers: headers,
      contentType: contentType,
      receiveDataWhenStatusError: true,
      method: method,
      responseType: responseType,
    ),
  );
}

class Album {
  final List<Question> questions;
  final int recordsFiltered;
  int pagesFiltered = 1;
  int startIndex = 0;
  int batchSize = 10;
  Album({
    required this.questions,
    required this.recordsFiltered,
    required this.startIndex,
    required this.batchSize,
  }) {
    pagesFiltered = (recordsFiltered / batchSize).ceil();
  }

  factory Album.fromJson(
      Map<String, dynamic> json, int startIndex, int batchSize) {
    List<Question> tQuestions = [];
    for (var item in (json['data'] as List<dynamic>)) {
      tQuestions.add(Question.fromJson(item));
    }
    return Album(
      recordsFiltered: json["recordsFiltered"],
      questions: tQuestions,
      startIndex: startIndex,
      batchSize: batchSize,
    );
  }
}

class Question {
  Album? parent;
  final int id;
  final String fileName;
  Uint8List? fileBytes;
  String? imgText;
  final List<Answer> answers;
  String? error;
  Question({
    required this.id,
    required this.fileName,
    required this.answers,
    this.imgText,
    this.error,
    this.parent,
  });

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
