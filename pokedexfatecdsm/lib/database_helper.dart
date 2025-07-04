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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE pokemons (
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT,
            image TEXT
          )
        ''');

        await db.insert('users', {'email': 'fatec@pokemon.com', 'password': 'pikachu'});

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
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }

  Future<List<Pokemon>> getPokemons() async {
    final db = await database;
    final result = await db.query('pokemons');
    return result.map((e) => Pokemon.fromMap(e)).toList();
  }

  // --- MÉTODO MODIFICADO ---
  Future<void> syncWithSpringApi() async {
    print("Iniciando sincronização com a API Spring...");
    final db = await database;

    final usersFromDb = await db.query('users');
    final pokemonsFromDb = await db.query('pokemons');

    // **INÍCIO DA MODIFICAÇÃO**
    // Processa a lista de usuários para remover a chave 'id' de cada mapa
    final usersPayload = usersFromDb.map((user) {
      final newUserMap = Map<String, dynamic>.from(user);
      newUserMap.remove('id'); // Remove o campo 'id'
      return newUserMap;
    }).toList();

    // Processa a lista de pokémons para remover a chave 'id'
    final pokemonsPayload = pokemonsFromDb.map((pokemon) {
      final newPokemonMap = Map<String, dynamic>.from(pokemon);
      newPokemonMap.remove('id'); // Remove o campo 'id'
      return newPokemonMap;
    }).toList();
    // **FIM DA MODIFICAÇÃO**


    // Monta o corpo da requisição com os dados processados (sem o 'id')
    final syncPayload = {
      'users': usersPayload,
      'pokemons': pokemonsPayload,
    };

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