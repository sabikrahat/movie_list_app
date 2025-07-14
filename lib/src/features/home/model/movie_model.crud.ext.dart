part of 'movie_model.dart';

extension MovieDBExtension on Movie {
  Future<void> saveData() async => await Boxes.movies.put(id, this);

  Future<void> deleteData() async => await Boxes.movies.delete(id);
}

extension ListMovieDBExt on List<Movie> {
  Future<void> saveAllData() async =>
      await Boxes.movies.putAll(Map.fromEntries(map((e) => MapEntry(e.id, e))));

  Future<void> deleteAllData() async => await Boxes.movies.deleteAll(map((e) => e.id).toList());
}
