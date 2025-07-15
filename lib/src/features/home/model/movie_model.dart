import 'dart:convert';
import 'dart:math';

import 'package:hive_ce/hive.dart';

import '../../../core/db/hive.dart';

part 'movie_model.crud.ext.dart';
part 'movie_model.g.dart';

@HiveType(typeId: HiveTypes.movies)
class Movie {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String description;
  @HiveField(3)
  bool isFavorite = false;
  @HiveField(4)
  DateTime created = DateTime.now();
  @HiveField(5)
  DateTime updated = DateTime.now();

  Movie() {
    // Generate ID only if not already set (for new instances)
    id = '${DateTime.now().microsecondsSinceEpoch + Random().nextInt(999999)}';
  }

  // copywith
  Movie copyWith({
    String? title,
    String? description,
    bool? isFavorite,
    DateTime? created,
    DateTime? updated,
  }) {
    final copy = Movie();
    copy.id = id; // Preserve the original ID
    copy.title = title ?? this.title;
    copy.description = description ?? this.description;
    copy.isFavorite = isFavorite ?? this.isFavorite;
    copy.created = created ?? this.created;
    copy.updated = updated ?? this.updated;
    return copy;
  }

  // from json
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie()
      ..id = json[_Json.id] as String
      ..title = json[_Json.title] as String
      ..description = json[_Json.description] as String
      ..isFavorite = json[_Json.isFavorite] as bool? ?? false
      ..created = DateTime.parse(json[_Json.created] as String)
      ..updated = DateTime.parse(json[_Json.updated] as String);
  }

  // from raw json
  factory Movie.fromRawJson(String str) =>
      Movie.fromJson(Map<String, dynamic>.from(json.decode(str)));

  // from json list
  static List<Movie> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => Movie.fromJson(json as Map<String, dynamic>)).toList();

  // from raw json list
  static List<Movie> fromRawJsonList(String str) => fromJsonList(json.decode(str) as List<dynamic>);

  // to json
  Map<String, dynamic> toJson() => {
    _Json.id: id,
    _Json.title: title,
    _Json.description: description,
    _Json.isFavorite: isFavorite,
    _Json.created: created.toIso8601String(),
    _Json.updated: updated.toIso8601String(),
  };

  // to raw json
  String toRawJson() => json.encode(toJson());

  // to json list
  static List<Map<String, dynamic>> toJsonList(List<Movie> movies) =>
      movies.map((movie) => movie.toJson()).toList();

  // to raw json list
  static String toRawJsonList(List<Movie> movies) => json.encode(toJsonList(movies));

  @override
  String toString() => toRawJson();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class _Json {
  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String isFavorite = 'is_favorite';
  static const String created = 'created';
  static const String updated = 'updated';
}
