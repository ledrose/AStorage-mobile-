import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/http/imageGetter.dart';
import 'package:flutter_application_1/http/search.dart';
import 'package:flutter_application_1/http/sender.dart';
import './http/base.dart';

class SearchPage extends StatefulWidget {

  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          searchBar(),
          Expanded(
            child: buildQuestionList(),
          ),
        ],
      ),
    );
  }
  Widget searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        child: TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Введите поисковый запрос',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.arrow_forward),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildQuestionList() {
    return FutureBuilder(
      future: createSearch(searchText: _textController.value.text),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text("Error has occured." + snapshot.error.toString());
            else
              return questionList(context, snapshot.data as Album);
          default:
            return Container();
        }
      },
    );
  }

  Widget questionList(BuildContext context, Album alb) {
    if (alb.questions.length != 0) {
      return Scrollbar(
        interactive: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [...alb.questions.map((q) => buildQuestionBlock(q))],
        ),
      );
    } else {
      return Center(
        child: Text("Вопросов по вашему запросу не было найдено"),
      );
    }
  }

  Widget buildQuestionBlock(Question q) {
    return FutureBuilder(
      future: getImage(q.id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Card(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text("Error has occured." + snapshot.error.toString());
            else
              return questionBlock(
                  context, q, Image.memory(snapshot.data as Uint8List));
          default:
            return Container();
        }
      },
    );
  }

  Widget questionBlock(BuildContext context, Question q, Widget img) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: img,
          ),
          Text(
            'Рассшифровка текста с картинки: ${q.imgText}',
            textAlign: TextAlign.start,
          ),
          ButtonBarTheme(
            data: ButtonBarThemeData(),
            child: ButtonBar(
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    _showQuestionDialog(context, q);
                  },
                  child: Text('Ответы ${q.answers.length}'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showQuestionDialog(BuildContext context, Question q) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 25, right: 25),
          title: Center(
            child: Text('Ответы'),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Scrollbar(
              interactive: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: answerList(q.answers),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _showAddAnswerDialog(context, q.id);
                  },
                  child: Text('Написать ответ'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Закрыть'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget answerList(List<Answer> ans) {
    if (ans.isEmpty)
      return Text(
        "Никто еще не написал ответа. Стань первым.",
        textAlign: TextAlign.center,
      );
    else
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[...ans.map((e) => answerListElement(e))],
      );
  }

  Widget answerListElement(Answer ans) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: double.infinity,
          child: Text(
            "Оценило ответ: " + ans.count.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          child: Text(
            "Ответило на вопрос: " + ans.percent.toString() + "%",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        Container(
          child: Text(
            "Данный ответ:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          child: Text(
            ans.answer,
          ),
        ),
        Divider(
          thickness: 3.0,
          color: Colors.blue,
        ),
      ],
    );
  }

  Future<void> _showAddAnswerDialog(BuildContext context, int id) async {
    TextEditingController _textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 25, right: 25),
          title: Center(
            child: Text('Напишите ответ'),
          ),
          content: TextFormField(
            controller: _textController,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    sendAnswer(id, _textController.value.text.trim())
                        .whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Ответ отправлен")));
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Отправить ответ"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Закрыть"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
