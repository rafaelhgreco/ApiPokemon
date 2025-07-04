import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models/pokemon.dart';

// 1. Converta para StatefulWidget
class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Pokemon>> _pokemonsFuture;

  @override
  void initState() {
    super.initState();
    // 2. Chama a sincronização e depois carrega os pokémons
    _iniciarSincronizacaoECarregarDados();
  }

  void _iniciarSincronizacaoECarregarDados() async {
    print("Iniciando sincronização com a API...");
    // Primeiro, tenta sincronizar com o servidor em segundo plano.
    // O 'await' aqui é opcional, mas garante que a tentativa de sync ocorra antes de carregar.
    await dbHelper.syncWithSpringApi();

    print("Carregando dados do banco de dados local...");
    // Depois, define o Future que o FutureBuilder vai usar.
    setState(() {
      _pokemonsFuture = dbHelper.getPokemons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémons")),
      // 3. Use a variável _pokemonsFuture no FutureBuilder
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum Pokémon encontrado."));
          }

          final pokemons = snapshot.data!;
          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final p = pokemons[index];
              return ListTile(
                leading: Image.asset(
                  p.image,
                  width: 50,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
                ),
                title: Text(p.name),
                subtitle: Text(p.type),
              );
            },
          );
        },
      ),
    );
  }
}