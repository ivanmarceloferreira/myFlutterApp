import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/logged_screen.dart';
import 'package:my_app/model/login.dart';
import 'package:http/http.dart' as http;

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<LoginForm>.
  final _formKey = GlobalKey<FormState>();

  bool? rememberMe = true;
  bool _passwordVisible = false;
  String _authToken = '';
  String _email = '';

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    loginTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  _onLogin() {
    if (_authToken == '') {
      debugPrint('não tem token, vai logar');
      _login()
          .then((value) => {navigateToLoggedRoute()})
          .onError((error, stackTrace) => {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Login inválido'),
                    );
                  },
                )
              });
    } else {
      debugPrint('já tá logado');
      navigateToLoggedRoute();
    }
  }

  Future<dynamic> navigateToLoggedRoute() {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoggedScreenRoute(email: _email)),
    );
  }

  Future<Login> _login() async {
    String? uri = dotenv.env['URI_REQUEST'];
    debugPrint('url da env $uri');

    final response = await http.post(
      Uri.parse('$uri/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': loginTextController.text,
        'password': passwordTextController.text
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      var body = response.body;
      debugPrint('retorno da requisicao $body');

      Login login =
          Login.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      setState(() {
        _authToken = login.authorization;
        _email = loginTextController.text;
      });
      return login;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      var body = response.body;
      debugPrint('resposta errada $body');
      throw Exception('Falha ao fazer o login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: (_authToken == '') ? Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Palmeiras_logo.svg/1024px-Palmeiras_logo.svg.png',
            width: 150,
            height: 150,
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Digite o seu email',
              labelText: 'Email *',
            ),
            validator: (String? value) {
              return (value != null && value.contains('@'))
                  ? 'Email inválido'
                  : null;
            },
            controller: loginTextController,
          ),
          TextFormField(
            decoration: InputDecoration(
                icon: const Icon(Icons.key),
                hintText: 'Digite a sua senha',
                labelText: 'Senha *',
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )),
            controller: passwordTextController,
            obscureText: !_passwordVisible,
            enableSuggestions: false,
            autocorrect: false,
          ),
          CheckboxListTile(
            // tileColor: Colors.blue,
            title: const Text('Me mantenha conectado'),
            value: rememberMe,
            onChanged: (bool? value) {
              setState(() {
                rememberMe = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              _onLogin();
            },
            child: const Text('Login')
          )
        ],
      ) : Center(
        child: Column(
          children: <Widget>[
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Palmeiras_logo.svg/1024px-Palmeiras_logo.svg.png',
              width: 150,
              height: 150,
            ),
            const Text(
              'Usuário já logado',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                navigateToLoggedRoute();
              },
              child: const Text('Entrar')
            )
          ]
        )
      ),
    );
  }
}
