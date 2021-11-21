import 'dart:typed_data';

String version='1.0';
String baseUrl = "https://bfs-astorage.somee.com";
String key = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjM2FiNjNkYS1jYmU5LTRiNjQtYjlkNi0xMWM2MDdjYjNjNDUiLCJpYXQiOjE2MzMzNTM4NDgsIkNyZWF0aW9uRGF0ZXRpbWUiOiIxMC80LzIwMjEgODoyNDowOCBQTSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJhZG1pbkBtYWlsLnJ1IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZW1haWxhZGRyZXNzIjoiYWRtaW5AbWFpbC5ydSIsInN1YiI6IjEiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjEiLCJzZWN1cml0eVN0YW1wIjoiUFhQWEZHTjVVVTNZNDJBU1JIUkVKVFFYVDdHVDVGSEgiLCJFeHBpcmVzSW4iOiIxMDAwMCIsIkNyZWF0ZVJvbGVzIjoiMSIsIkRlbGV0ZUZpbGVzIjoiMiIsIkdldExvZ3MiOiIyMDAiLCJuYmYiOjE2MzMzNTM4NDgsImV4cCI6MTY2OTM1NzQ0OCwiaXNzIjoiaHR0cHM6Ly9iZnMtYXN0b3JhZ2Uuc29tZWUuY29tLyIsImF1ZCI6IkFTdG9yYWdlX2FwaSJ9.NK_Q_715pMQFnw1B4W1-D3IQzT5XsHFQy-4D77bZ7HM";
String halfLink = '$baseUrl/api/v$version';

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
  factory Album.debug({required List<Question> questions}) {
    return Album(questions: questions);
  }
}

class Question {
  final int id;
  final String fileName;
  Uint8List? fileBytes;
  String? imgText;
  final List<Answer> answers;
  Question({required this.id, required this.fileName, required this.answers, this.imgText});
  
  factory Question.fromJson(Map<dynamic, dynamic> json) {
    List<Answer> tAnswers = [];
    for (var item in (json['averageAnswers'] as List<dynamic>)) {
      tAnswers.add(Answer.fromJson(item));
    }
    if (json['text'].toString().isEmpty) {
      return Question(
        id: json['id'], fileName: json['fileName'], answers: tAnswers, imgText: json['text']); //TODO check naming of field 'text'
    } else {
      return Question(
        id: json['id'], fileName: json['fileName'], answers: tAnswers);
    }
  }
  // ignore: avoid_init_to_null
  factory Question.debug({required int id,required String fileName,required List<Answer> answers,String? imgText}) {
    return Question(id: id, fileName: fileName, answers: answers,imgText: imgText);
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
