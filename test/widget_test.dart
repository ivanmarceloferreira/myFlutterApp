import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/components/login_form.dart';
import 'package:my_app/controllers/login_controller.dart';

import 'widget_test.mocks.dart';


@GenerateMocks([http.Client])
void main() async {
  // DotEnv dotEnv = DotEnv();

  // TestWidgetsFlutterBinding.ensureInitialized();
  // await dotEnv.load();

  testWidgets('LoginForm widget test', (WidgetTester tester) async {
    // Create a mock http.Client
    final MockClient mockHttpClient = MockClient();

    // Create a LoginController with the mock http.Client
    final loginController = LoginController(httpClient: mockHttpClient);

    when(mockHttpClient.post(Uri.parse("https://serverest.dev/login"),
        body: anyNamed('body'),
        headers: anyNamed('headers')))
    .thenAnswer((_) async => http.Response('{"status": 200}', 200));

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: LoginForm(loginController: loginController),
      ),
    ));

    debugPrint('criou o widget');

    // Enter text into the username and password fields
    var emailInput = find.byType(TextFormField).at(0);
    await tester.enterText(emailInput, 'test_username');

    var passInput = find.byType(TextFormField).at(1);
    await tester.enterText(passInput, 'test_password');

    // // Tap the login button
    var loginButton = find.byType(ElevatedButton);
    await tester.tap(loginButton);
    
    await tester.pump();

    expect(emailInput, findsOneWidget);
    expect(passInput, findsOneWidget);
    expect(loginButton, findsOneWidget);

    // Verify that the login method of the mock loginController was called
    verify(mockHttpClient.post(Uri.parse("https://serverest.dev/login"),
        body: anyNamed('body'),
        headers: anyNamed('headers'))).called(1);
  });

}
