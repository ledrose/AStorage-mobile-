import 'package:flutter/material.dart';
import './http/base.dart';
import 'searchBar.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: questionList(context, testAlbum)
    );
  }

  Widget questionList(BuildContext context, Album alb) {
    return Scrollbar(
      interactive: true,
      child: ListView(
        children: [SearchBar(),
          ...alb.questions.map(
              (e) => questionBlock(context, e, Image.asset('images/1.png'))),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  _showQuestionDialog(context, testQuestion1);
                },
                child: Text('Show Dialog')),
          ),
        ],
      ),
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
                  onPressed: () {},
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
            "Положительных отзывов: " + ans.percent.toString() + "%",
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

  BoxDecoration TestBexDecoration = BoxDecoration(
    border: Border.all(
      width: 10.0,
      color: Colors.red,
    ),
  );
  Answer testAnswer1 = Answer(
      answer:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pulvinar elementum integer enim neque volutpat. Et tortor consequat id porta nibh venenatis. Volutpat sed cras ornare arcu dui vivamus. Pellentesque habitant morbi tristique senectus. Nunc mattis enim ut tellus elementum sagittis vitae et. Rhoncus mattis rhoncus urna neque viverra justo nec ultrices. In aliquam sem fringilla ut morbi tincidunt augue. Viverra tellus in hac habitasse platea dictumst vestibulum. Sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Commodo sed egestas egestas fringilla. Sollicitudin nibh sit amet commodo nulla facilisi nullam vehicula. Massa massa ultricies mi quis hendrerit dolor.",
      count: 4,
      percent: 75);
  Answer testAnswer2 = Answer(
      answer:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Urna et pharetra pharetra massa massa ultricies mi. Sed viverra ipsum nunc aliquet bibendum enim. In nulla posuere sollicitudin aliquam ultrices. Nisl vel pretium lectus quam id leo. Erat imperdiet sed euismod nisi porta. Scelerisque eu ultrices vitae auctor eu augue ut lectus arcu. Vulputate ut pharetra sit amet aliquam id diam maecenas. Malesuada pellentesque elit eget gravida. Blandit libero volutpat sed cras. Sed velit dignissim sodales ut eu sem integer vitae. Ut diam quam nulla porttitor massa id neque aliquam vestibulum. Nisi porta lorem mollis aliquam ut porttitor. Libero id faucibus nisl tincidunt eget nullam non nisi est. Sed viverra tellus in hac habitasse. Dictumst quisque sagittis purus sit amet volutpat consequat mauris nunc. Viverra adipiscing at in tellus integer feugiat scelerisque varius. Diam sit amet nisl suscipit adipiscing bibendum est ultricies.",
      count: 1,
      percent: 0);
  Question testQuestion1 =
      Question.debug(id: 4, fileName: "1.png", answers: []);
  Question testQuestion2 =
      Question.debug(id: 5, fileName: "2.png", answers: []);
  Album testAlbum = Album.debug(questions: [
    Question.debug(id: 4, fileName: "1.png", imgText: "Hello there!", answers: [
      Answer(
          answer:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pulvinar elementum integer enim neque volutpat. Et tortor consequat id porta nibh venenatis. Volutpat sed cras ornare arcu dui vivamus. Pellentesque habitant morbi tristique senectus. Nunc mattis enim ut tellus elementum sagittis vitae et. Rhoncus mattis rhoncus urna neque viverra justo nec ultrices. In aliquam sem fringilla ut morbi tincidunt augue. Viverra tellus in hac habitasse platea dictumst vestibulum. Sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Commodo sed egestas egestas fringilla. Sollicitudin nibh sit amet commodo nulla facilisi nullam vehicula. Massa massa ultricies mi quis hendrerit dolor.",
          count: 4,
          percent: 75),
      Answer(
          answer:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Urna et pharetra pharetra massa massa ultricies mi. Sed viverra ipsum nunc aliquet bibendum enim. In nulla posuere sollicitudin aliquam ultrices. Nisl vel pretium lectus quam id leo. Erat imperdiet sed euismod nisi porta. Scelerisque eu ultrices vitae auctor eu augue ut lectus arcu. Vulputate ut pharetra sit amet aliquam id diam maecenas. Malesuada pellentesque elit eget gravida. Blandit libero volutpat sed cras. Sed velit dignissim sodales ut eu sem integer vitae. Ut diam quam nulla porttitor massa id neque aliquam vestibulum. Nisi porta lorem mollis aliquam ut porttitor. Libero id faucibus nisl tincidunt eget nullam non nisi est. Sed viverra tellus in hac habitasse. Dictumst quisque sagittis purus sit amet volutpat consequat mauris nunc. Viverra adipiscing at in tellus integer feugiat scelerisque varius. Diam sit amet nisl suscipit adipiscing bibendum est ultricies.",
          count: 1,
          percent: 0),
    ]),
    Question.debug(
        id: 5,
        fileName: "2.png",
        imgText: "Absolutely not hello there!",
        answers: [])
  ]);
}
