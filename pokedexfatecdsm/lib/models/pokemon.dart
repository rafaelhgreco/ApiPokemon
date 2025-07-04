class Pokemon {
  final int id;
  final String name;
  final String type;
  final String image;

  Pokemon({required this.id, required this.name, required this.type, required this.image});

  // Método fromMap para criar um objeto a partir de um mapa (v_indo do DB)
  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      image: map['image'],
    );
  }

  // CORREÇÃO AQUI: As chaves devem ser em inglês para corresponder à API.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
    };
  }
}