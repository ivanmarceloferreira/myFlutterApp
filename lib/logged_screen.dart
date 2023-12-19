import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/model/usuario.dart';
import 'package:http/http.dart' as http;

class LoggedScreenRoute extends StatefulWidget {
  const LoggedScreenRoute({super.key, required this.email});
  
  final String email;
  
  @override
  LoggedScreenState createState() {
    return LoggedScreenState();
  }

}

class LoggedScreenState extends State<LoggedScreenRoute> {

  Usuario _usuario = const Usuario(nome: 'nome', email: 'email', password: 'password', administrator: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => findUserByEmail());
  }

  void findUserByEmail() async {
    String? uri = dotenv.env['URI_REQUEST'];
    debugPrint('url da env $uri');

    String email = widget.email;
    
    final response = await http.get(
      Uri.parse('$uri/usuarios?email=$email'),
    );

    if (response.statusCode == 200) {

      var resp = jsonDecode(response.body);
      debugPrint('retorno da requisicao $resp');

      Usuario usuario = Usuario.fromJson(resp['usuarios'][0] as Map<String, dynamic>);
      setState(() {
        _usuario = usuario;
      });

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      var body = response.body;
      debugPrint('resposta errada $body');
      throw Exception('Falha ao buscar o usuário');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Email ${_usuario.email}'),
            Text('Nome ${_usuario.nome}'),
            Text('Senha ${_usuario.password}'),
            Text('Administrator ${_usuario.administrator ? 'Sim' : 'Não'}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Voltar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Logoff'),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}