class Login {
  final String message;
  final String authorization;

  const Login({required this.message, required this.authorization});

  factory Login.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'message': String message,
        'authorization': String authorization,
      } =>
        Login(
          message: message,
          authorization: authorization,
        ),
      _ => throw const FormatException('Falha ao carregar o objeto login.'),
    };
  }
}