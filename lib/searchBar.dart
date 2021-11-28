import 'package:flutter/material.dart';
import 'package:flutter_application_1/http/search.dart';
import './http/base.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        child: TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Введите поисковый запрос',
            suffixIcon: IconButton(
              onPressed: () {
                createSearch();
              },
              icon: Icon(Icons.arrow_forward),
            ),
          ),
        ),
      ),
    );
  }
}
