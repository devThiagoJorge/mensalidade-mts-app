class User {
  final String token;
  final String nome;

  User({required this.token, required this.nome});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(token: json['token'] as String, nome: json['nome'] as String);
  }
}
