
import 'package:flutter/material.dart';
import 'package:my_app/logged_screen.dart';
import 'package:my_app/model/login.dart';
import 'package:my_app/controllers/login_controller.dart';

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  
  final LoginController loginController;

  const LoginForm({Key? key, required this.loginController}) : super(key: key);

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
      widget.loginController.login(loginTextController.text, passwordTextController.text)
          .then((value) => { navigateToLoggedRoute(value) })
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
      navigateToLoggedRoute(Login(message: "", authorization: _authToken));
    }
  }

  Future<dynamic> navigateToLoggedRoute(Login value) {
    debugPrint('vai logar meu fiiii ');

    setState(() {
      _authToken = value.authorization;
      _email = loginTextController.text;
    });

    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoggedScreenRoute(email: _email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: (_authToken == '') ? Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          // Image.network(
          //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Palmeiras_logo.svg/1024px-Palmeiras_logo.svg.png',
          //   width: 150,
          //   height: 150,
          // ),
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
            // Image.network(
            //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Palmeiras_logo.svg/1024px-Palmeiras_logo.svg.png',
            //   width: 150,
            //   height: 150,
            // ),
            const Text(
              'Usuário já logado',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                navigateToLoggedRoute(Login(message: "", authorization: _authToken));
              },
              child: const Text('Entrar')
            )
          ]
        )
      ),
    );
  }
}
