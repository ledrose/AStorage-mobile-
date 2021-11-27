import 'package:flutter/material.dart';
import 'package:flutter_application_1/http/base.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './http/sender.dart';

class SendPage extends StatelessWidget {
  const SendPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SendForm(),
    );
  }
}

class SendForm extends StatefulWidget {
  SendForm({Key? key}) : super(key: key);

  @override
  _SendFormState createState() => _SendFormState();
}

class _SendFormState extends State<SendForm> {
  XFile? _imageFile;
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imageTaker(),
        SizedBox(
          height: 20.0,
        ),
        TextField(
          controller: _controller,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        ElevatedButton(
          onPressed: () async {
            SnackBar snackBar;
            if (_imageFile == null) {
              snackBar = SnackBar(
                content: Text("You did not choose an image"),
              );
            } else {
              Question q = await sendImageDio(_imageFile!).then((q) => q);
              if (q.error == null) {
                String value = _controller.value.text;
                snackBar = SnackBar(content: Text("You typed: $value"));
                if (_controller.value.text.trim() != "") {
                  await sendAnswer(q.id, _controller.value.text)
                      .whenComplete(() => null);
                  snackBar = SnackBar(content: Text("Ответ принят"));
                }
              } else {
                snackBar = SnackBar(content: Text(q.error!));
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Text("Send data"),
        ),
        ElevatedButton(
            onPressed: () {
              sendAnswer(50, "Тестирование продолжаааааается")
                  .whenComplete(() => null);
            },
            child: Text("Test Button")),
      ],
    );
  }

  Widget imageTaker() {
    return Center(
      child: Stack(
        children: [
          Image(
            height: 300.0,
            image: (_imageFile == null)
                ? AssetImage('images/1.png')
                : FileImage(File(_imageFile!.path)) as ImageProvider,
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => bottomSheet(),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 56.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose picture",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Camera")),
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }
}
