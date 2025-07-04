class Usuario {
  final int? id;
  final String email;
  final String password;

  Usuario({this.id, required this.email, required this.password});

  // Método fromMap para criar um objeto a partir de um mapa (vindo do DB)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
}