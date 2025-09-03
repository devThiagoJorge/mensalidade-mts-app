class User {
  final String token;
  final String nome;
  final String role;
  final int id;
  final String gestaoAtual;

  User({
    required this.token,
    required this.nome,
    required this.role,
    required this.id,
    required this.gestaoAtual,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'] as String,
      nome: json['nome'] as String,
      role: json['role'] as String,
      gestaoAtual: json['gestaoAtual'] as String,
      id: json['id'] as int,
    );
  }
}
