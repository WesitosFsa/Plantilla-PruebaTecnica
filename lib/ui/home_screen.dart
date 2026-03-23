import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final HiveService _hiveService = HiveService();
  final TextEditingController _idController = TextEditingController();

  Pokemon? _searchResult;
  List<Pokemon> _capturedPokemons = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCaptured();
  }

  Future<void> _loadCaptured() async {
    final list = await _hiveService.getCapturedPokemons();
    setState(() {
      _capturedPokemons = list;
    });
  }

  Future<void> _search() async {
    if (_idController.text.isEmpty) return;
    setState(() => _isLoading = true);
    final result = await _apiService.getPokemon(int.parse(_idController.text));
    setState(() {
      _searchResult = result;
      _isLoading = false;
    });
  }

  // CREATE: Capturar y guardar local (Permitiendo duplicados)
  Future<void> _capture() async {
    if (_searchResult == null) return;
    
    setState(() => _isLoading = true);
    
    // Creamos una COPIA nueva para que Hive lo guarde como un nuevo registro
    final newPokemon = Pokemon(
      id: _searchResult!.id,
      name: _searchResult!.name,
      imageUrl: _searchResult!.imageUrl,
      height: _searchResult!.height,
      weight: _searchResult!.weight,
    );

    final bytes = await _apiService.downloadImageBytes(newPokemon.imageUrl);
    newPokemon.imageBytes = bytes;

    await _hiveService.savePokemon(newPokemon);
    await _loadCaptured(); 
    
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Pokemon capturado!')),
    );
  }

  void _editPokemon(Pokemon pokemon) {
    final nameController = TextEditingController(text: pokemon.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Pokemon'),
        content: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              pokemon.name = nameController.text;
              await _hiveService.updatePokemon(pokemon);
              _loadCaptured();
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('PokeAPI CRUD'),
          bottom: const TabBar(
            tabs: [Tab(icon: Icon(Icons.search), text: 'Buscar API'), Tab(icon: Icon(Icons.catching_pokemon), text: 'Capturados')],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSearchTab(),
            _buildCapturedTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _idController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'ID del Pokemon (1-1025)',
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: (_) => _search(),
          ),
          const SizedBox(height: 20),
          if (_isLoading) const CircularProgressIndicator(),
          if (_searchResult != null) ...[
            Text(_searchResult!.name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network(_searchResult!.imageUrl, height: 150),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _capture,
              icon: const Icon(Icons.add),
              label: const Text('Capturar (Guardar local)'),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildCapturedTab() {
    if (_capturedPokemons.isEmpty) {
      return const Center(child: Text('No tienes pokemons capturados.'));
    }
    return ListView.builder(
      itemCount: _capturedPokemons.length,
      itemBuilder: (context, index) {
        final p = _capturedPokemons[index];
        return ListTile(
          leading: p.imageBytes != null
              ? Image.memory(p.imageBytes!, width: 50)
              : const Icon(Icons.image_not_supported),
          title: Text(p.name),
          subtitle: Text('ID API: ${p.id}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editPokemon(p)),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  // USAMOS p.key PARA BORRAR EL REGISTRO ÚNICO
                  await _hiveService.deletePokemon(p.key);
                  _loadCaptured();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
