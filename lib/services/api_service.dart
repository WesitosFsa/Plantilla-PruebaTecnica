import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../models/pokemon.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  // Traer datos de la API
  Future<Pokemon?> getPokemon(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');
      if (response.statusCode == 200) {
        return Pokemon.fromJson(response.data);
      }
    } catch (e) {
      print('Error al traer pokemon: $e');
    }
    return null;
  }

  // Descargar imagen como Bytes (Compatible con Web y Móvil)
  Future<Uint8List?> downloadImageBytes(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      }
    } catch (e) {
      print('Error al descargar imagen: $e');
    }
    return null;
  }
}
