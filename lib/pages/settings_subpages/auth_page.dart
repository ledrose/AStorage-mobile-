import 'package:flutter/material.dart';
import 'package:flutter_application_1/global_things/settings.dart';
import 'package:flutter_application_1/http/authtorization.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Войдите в аккаунт"),
      ),
      body: loginWidget(),
    );
  }

  Widget loginWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return "Вы не ввели почту";
                  } else if (value.contains('@') && value.contains('.')) {
                    return null;
                  } else {
                    return "Вы ввели не почту";
                  }
                }
                return "Ошибка. Этого не должно было произойти";
              },
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Адрес почты',
                hintText: 'example@mail.ru',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return "Вы не ввели пароль";
                  } else {
                    return null;
                  }
                }
                return "Ошибка. Этого не должно было произойти";
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Пароль',
                hintText: 'Введите пароль',
              ),
            ),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
            ),
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  String? token = await getToken(
                    _emailController.value.text,
                    _passwordController.value.text,
                  );
                  if (token == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Error")));
                  } else {
                    curUser =User(token: token);
                  }
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
