import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'pokemon.g.dart';

@HiveType(typeId: 0)
class Pokemon extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  Uint8List? imageBytes;

  @HiveField(4)
  int height;

  @HiveField(5)
  int weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.imageBytes,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'] ?? '',
      height: json['height'],
      weight: json['weight'],
    );
  }
}
