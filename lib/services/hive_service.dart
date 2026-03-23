import 'package:hive/hive.dart';
import '../models/pokemon.dart';

class HiveService {
  static const String boxName = 'captured_pokemons';

  // Abrir la caja
  Future<Box<Pokemon>> openBox() async {
    return await Hive.openBox<Pokemon>(boxName);
  }

  // CREATE: Guardar Pokemon (add genera una clave única automática)
  Future<void> savePokemon(Pokemon pokemon) async {
    final box = await openBox();
    await box.add(pokemon); 
  }

  // READ: Obtener todos los guardados
  Future<List<Pokemon>> getCapturedPokemons() async {
    final box = await openBox();
    return box.values.toList();
  }

  // UPDATE: Editar datos del Pokemon
  Future<void> updatePokemon(Pokemon pokemon) async {
    await pokemon.save(); // HiveObject gestiona su propia clave
  }

  // DELETE: Eliminar usando la clave única de la base de datos (key)
  Future<void> deletePokemon(dynamic key) async {
    final box = await openBox();
    await box.delete(key);
  }
}
