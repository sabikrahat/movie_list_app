import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/movie_model.dart';

import '../../../core/db/hive.dart';
import '../../../core/exception/exception.dart';
import '../../../core/utils/logger/logger_helper.dart';

final homeProvider = AsyncNotifierProvider<HomeProvider, List<Movie>>(HomeProvider.new);

class HomeProvider extends AsyncNotifier<List<Movie>> {
  late List<Movie> _movies;
  @override
  Future<List<Movie>> build() async {
    _movies = [];
    _movies = await loadMovies();
    await Future.delayed(const Duration(seconds: 5));
    return _movies;
  }

  List<Movie> get data => _movies;

  Future<List<Movie>> loadMovies() async {
    try {
      final movies = Boxes.movies.values.toList();
      movies.sort((a, b) => b.created.compareTo(a.created));
      log.i('Loaded ${movies.length} movies');
      return movies;
    } catch (e) {
      log.e('Error loading movies: $e');
      throw KException('Failed to load movies: $e');
    }
  }

  Future<void> refresh({bool showLoader = true}) async {
    if (showLoader) EasyLoading.show();
    _movies = await loadMovies();
    if (showLoader) EasyLoading.dismiss();
    ref.notifyListeners();
  }

  Future<void> toggleFavorite(Movie movie) async {
    EasyLoading.show();
    try {
      final updatedMovie = movie.copyWith(isFavorite: !movie.isFavorite, updated: DateTime.now());
      await updatedMovie.saveData();
      await refresh();
    } catch (e) {
      log.e('Error toggling favorite: $e');
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
