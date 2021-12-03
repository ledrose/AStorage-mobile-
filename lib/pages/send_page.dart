import 'package:flutter/material.dart';
import 'package:flutter_application_1/global_things/base.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../http/sender.dart';

class SendPage extends StatelessWidget {
  const SendPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SendForm(),
    );
  }
}

class SendForm extends StatefulWidget {
  const SendForm({Key? key}) : super(key: key);

  @override
  _SendFormState createState() => _SendFormState();
}

class _SendFormState extends State<SendForm> {
  XFile? _imageFile;
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isButtonDisabled = false;
  
  void _sendFile() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You did not choose an image")));
    } else {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Файл-картинка равна null")));
      } else {
        setState(() {
          _isButtonDisabled = true;
        });
        Question q = await sendImageDio(_imageFile!).then((q) => q);
        if (q.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Картинка отправлена")));
          if (_controller.value.text.trim() != "") {
            String responseString=await sendAnswer(q.id, _controller.value.text);
            // if (==200) {
              ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(responseString)));
              
            // }
            // else {
            //   ScaffoldMessenger.of(context)
            //     .showSnackBar(const SnackBar(content: Text("Ошибка при добавлении ответа")));
            // }
            
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(q.error!)));
        }
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imageTaker(),
        const SizedBox(
          height: 20.0,
        ),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(border: OutlineInputBorder(),prefixText: "Введите ответ, если хотите"),
        ),
        ElevatedButton(
          onPressed: (_isButtonDisabled) ? null : _sendFile,
          child: const Text("Send data"),
        ),
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
                ? const AssetImage('images/placeholder.jpg')
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
              child: const Icon(
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
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose picture",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
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
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera")),
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Gallery")),
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
