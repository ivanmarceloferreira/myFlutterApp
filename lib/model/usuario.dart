class Usuario {
  final String nome;
  final String email;
  final String password;
  final bool administrator;

  const Usuario({required this.nome, 
                required this.email,
                required this.password,
                required this.administrator});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'nome': String nome,
        'email': String email,
        'password': String password,
        'administrador': String administrator,
      } =>
        Usuario(
          nome: nome,
          email: email,
          password: password,
          administrator: bool.parse(administrator)
        ),
      _ => throw const FormatException('Falha ao carregar o objeto Usuário.'),
    };
  }
}