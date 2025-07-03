import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/usuario.dart';
import 'models/pokemon.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1, // Se precisar alterar a estrutura, incremente a versão e use onUpgrade
      onCreate: (db, version) async {
        // Tabela de usuários com colunas em inglês
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        // Tabela de pokémons com colunas em inglês
        await db.execute('''
          CREATE TABLE pokemons (
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT,
            image TEXT
          )
        ''');

        // Inserindo usuário de exemplo com chaves em inglês
        await db.insert('users', {'email': 'fatec@pokemon.com', 'password': 'pikachu'});

        // Lista de pokémons com chaves em inglês
        List<Map<String, dynamic>> pokemons = [
          {'id': 1, 'name': 'Bulbasaur', 'type': 'Grass/Poison', 'image': 'assets/images/bulbasaur.png'},
          {'id': 4, 'name': 'Charmander', 'type': 'Fire', 'image': 'assets/images/charmander.png'},
          {'id': 7, 'name': 'Squirtle', 'type': 'Water', 'image': 'assets/images/squirtle.png'},
        ];

        for (var p in pokemons) {
          await db.insert('pokemons', p);
        }
      },
    );
  }

  Future<Usuario?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?', // Coluna 'password'
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first); // Assumindo um construtor fromMap no seu modelo
    }
    return null;
  }

  Future<List<Pokemon>> getPokemons() async {
    final db = await database;
    final result = await db.query('pokemons');
    // Mapeando com chaves em inglês
    return result.map((e) => Pokemon.fromMap(e)).toList(); // Assumindo um construtor fromMap no seu modelo
  }

  // Novo método de sincronização em LOTE para a API Spring
  Future<void> syncWithSpringApi() async {
    print("Iniciando sincronização com a API Spring...");
    final db = await database;

    final users = await db.query('users');
    final pokemons = await db.query('pokemons');

    // Monta o corpo da requisição em um único objeto JSON
    final syncPayload = {
      'users': users,
      'pokemons': pokemons,
    };

    // ATENÇÃO: Se estiver testando em um emulador Android, use '10.0.2.2' para acessar o localhost da sua máquina.
    // Se estiver em um dispositivo físico, use o IP da sua máquina na rede local (ex: '192.168.1.10').
    final url = Uri.parse('http://10.0.2.2:8080/api/sync');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(syncPayload),
      );

      if (response.statusCode == 200) {
        print('Sincronização bem-sucedida!');
        print('Resposta do servidor: ${response.body}');
      } else {
        print('Falha na sincronização. Status: ${response.statusCode}');
        print('Erro: ${response.body}');
      }
    } catch (e) {
      print('Erro de conexão durante a sincronização: $e');
    }
  }
}