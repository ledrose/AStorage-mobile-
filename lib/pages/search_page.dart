import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/global_things/settings.dart';
import 'package:flutter_application_1/http/image_getter.dart';
import 'package:flutter_application_1/http/search.dart';
import 'package:flutter_application_1/http/sender.dart';
import '../global_things/base.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Album? globalAlbum;
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          searchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                setState(() {
                  globalAlbum = null;
                });
                return Future.delayed(const Duration(milliseconds: 1000));
              },
              child: buildQuestionList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        child: TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Введите поисковый запрос',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  globalAlbum = null;
                });
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildQuestionList() {
    return (globalAlbum != null)
        ? questionList(context)
        : FutureBuilder(
            future: createSearch(searchText: _textController.value.text),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                        "Error has occured." + snapshot.error.toString());
                  } else {
                    globalAlbum = snapshot.data as Album;
                    return questionList(context);
                  }
                default:
                  return Container();
              }
            },
          );
  }

  Widget questionList(BuildContext context) {
    if (globalAlbum!.questions.isNotEmpty) {
      return Scrollbar(
        interactive: true,
        child: ListView(
          cacheExtent: MediaQuery.of(context).size.height * 10,
          scrollDirection: Axis.vertical,
          children: [
            ...globalAlbum!.questions.map((q) => buildQuestionBlock(q))
          ],
        ),
      );
    } else {
      return const Center(
        child: Text("Вопросов по вашему запросу не было найдено"),
      );
    }
  }

  Widget buildQuestionBlock(Question q) {
    return (q.fileBytes != null)
        ? questionBlock(context, q, Image.memory(q.fileBytes!))
        : FutureBuilder(
            future: getImage(q.id),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Card(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                        "Error has occured." + snapshot.error.toString());
                  } else {
                    q.fileBytes = snapshot.data as Uint8List;
                    return questionBlock(
                        context, q, Image.memory(snapshot.data as Uint8List));
                  }
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
          // Text(  //TODO
          //   'Рассшифровка текста с картинки: ${q.imgText}',
          //   textAlign: TextAlign.start,
          // ),
          ButtonBarTheme(
            data: const ButtonBarThemeData(),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    if (curUser.permissions.contains("DeleteFiles")) {
                      if (await deleteQuestion(q.id) == 200) {
                        setState(() {
                          globalAlbum!.questions.remove(q);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Ошибка: файл не был удален")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "У вас нет прав на соверешение этого действия")));
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 35.0,
                    color: Colors.red,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    _showQuestionDialog(context, q);
                  },
                  child: Text('Ответы ${q.answers.length}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //     Positioned(
    //       bottom: 10.0,
    //       left: 20.0,
    //       child: IconButton(
    //         onPressed: () {
    //           deleteQuestion(q.id);
    //           setState(() {
    //             globalAlbum!.questions.remove(q);
    //           });
    //         },
    //         icon: const Icon(
    //           Icons.delete,
    //           size: 40.0,
    //           color: Colors.red,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Future<void> _showQuestionDialog(BuildContext context, Question q) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(
            child: Text('Ответы'),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SizedBox(
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
                  child: const Text('Написать ответ'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget answerList(List<Answer> ans) {
    if (ans.isEmpty) {
      return const Text(
        "Никто еще не написал ответа. Стань первым.",
        textAlign: TextAlign.center,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[...ans.map((e) => answerListElement(e))],
      );
    }
  }

  Widget answerListElement(Answer ans) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Оценило ответ: " + ans.count.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            "Ответило на вопрос: " + ans.percent.toString() + "%",
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        const Text(
          "Данный ответ:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            ans.answer,
          ),
        ),
        const Divider(
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
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(
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
                          const SnackBar(content: Text("Ответ отправлен")));
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text("Отправить ответ"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Закрыть"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
