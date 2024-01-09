
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/controllers/login_controller.dart';
import 'package:my_app/model/login.dart';

import 'login_controller_test.mocks.dart';

@GenerateMocks([LoginController])
void main() {

  group('fetchAlbum', () {

    test('returns an Album if the http call completes successfully', () async {
      final controller = MockLoginController();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(controller
              .login('teste', 'teste'))
          .thenAnswer((_) async =>
              const Login(message: "message", authorization: "authorization"));

    });

  });

}