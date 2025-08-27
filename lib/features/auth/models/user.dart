class User {
  final String token;
  final String nome;
  final String role;
  final int id;

  User({
    required this.token,
    required this.nome,
    required this.role,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'] as String,
      nome: json['nome'] as String,
      role: json['role'],
      id: json['id'] as int,
    );
  }
}
