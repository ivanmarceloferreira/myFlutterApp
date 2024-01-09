
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_app/model/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LoginController {

  final http.Client httpClient;

  LoginController({required this.httpClient});

  Future<Login> login(String login, String password) async {
    debugPrint('entrou no controller');

    // String? uri = dotenv.env['URI_REQUEST'];
    // if (uri == null) {
    //   debugPrint('não tem env');  
    // }
    // debugPrint('url da env $uri');

    final response = await httpClient.post(
      Uri.parse('https://serverest.dev/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': login,
        'password': password
      }),
    );

    debugPrint('respondeu $response');

    if (response.statusCode == 200) {
      debugPrint('respondeu 200');
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      var body = response.body;
      debugPrint('retorno da requisicao $body');

      Login login =
          Login.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      return login;
    } else {
      debugPrint('deu pau na requisicao');
      // If the server did not return a 200 OK response,
      // then throw an exception.
      var body = response.body;
      debugPrint('resposta errada $body');
      throw Exception('Falha ao fazer o login');
    }
  }

}