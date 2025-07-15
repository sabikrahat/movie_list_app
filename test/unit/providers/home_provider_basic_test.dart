import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_list_app/src/features/home/model/movie_model.dart';
import 'package:movie_list_app/src/features/home/provider/home_provider.dart';
import 'package:movie_list_app/src/core/exception/exception.dart';
import '../../helpers/hive_test_helper.dart';

void main() {
  group('HomeProvider Basic Tests', () {
    late ProviderContainer container;

    setUpAll(() async {
      await HiveTestHelper.initializeHive();
    });

    setUp(() async {
      await HiveTestHelper.clearAllBoxes();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    tearDownAll(() async {
      await HiveTestHelper.cleanupHive();
    });

    group('Provider Configuration', () {
      test('should have correct provider type', () {
        expect(homeProvider, isA<AsyncNotifierProvider<HomeProvider, List<Movie>>>());
      });

      test('should be able to read provider notifier', () async {
        final notifier = container.read(homeProvider.notifier);
        expect(notifier, isA<HomeProvider>());
      });

      test('should initialize with loading state', () async {
        final asyncValue = container.read(homeProvider);
        expect(asyncValue, isA<AsyncLoading<List<Movie>>>());
      });
    });

    group('Movie Operations Logic', () {
      test('should create updated movie with correct properties for favorite toggle', () {
        final originalMovie = Movie()
          ..title = 'Test Movie'
          ..description = 'Test Description'
          ..isFavorite = false;
        
        final originalFavoriteStatus = originalMovie.isFavorite;
        final updateTime = DateTime.now();
        
        final updatedMovie = originalMovie.copyWith(
          isFavorite: !originalMovie.isFavorite,
          updated: updateTime,
        );
        
        expect(updatedMovie.isFavorite, equals(!originalFavoriteStatus));
        expect(updatedMovie.updated, equals(updateTime));
        expect(updatedMovie.id, equals(originalMovie.id));
        expect(updatedMovie.title, equals(originalMovie.title));
        expect(updatedMovie.description, equals(originalMovie.description));
        expect(updatedMovie.created, equals(originalMovie.created));
      });

      test('should preserve original movie when creating copy', () {
        final originalMovie = Movie()
          ..title = 'Test Movie'
          ..description = 'Test Description'
          ..isFavorite = true;
        
        final originalFavoriteStatus = originalMovie.isFavorite;
        
        final updatedMovie = originalMovie.copyWith(isFavorite: !originalMovie.isFavorite);
        
        expect(originalMovie.isFavorite, equals(originalFavoriteStatus));
        expect(updatedMovie.isFavorite, equals(!originalFavoriteStatus));
      });
    });

    group('Data Sorting Logic', () {
      test('should sort movies by creation date correctly', () {
        final testMovies = [
          Movie()
            ..title = 'Movie 1'
            ..created = DateTime(2023, 1, 1),
          Movie()
            ..title = 'Movie 2'
            ..created = DateTime(2023, 1, 2),
          Movie()
            ..title = 'Movie 3'
            ..created = DateTime(2023, 1, 3),
        ];

        testMovies.sort((a, b) => b.created.compareTo(a.created));
        
        expect(testMovies[0].title, equals('Movie 3')); // Newest
        expect(testMovies[1].title, equals('Movie 2')); // Middle
        expect(testMovies[2].title, equals('Movie 1')); // Oldest
      });

      test('should handle empty movie list sorting', () {
        final emptyList = <Movie>[];
        emptyList.sort((a, b) => b.created.compareTo(a.created));
        
        expect(emptyList, isEmpty);
      });

      test('should handle single movie sorting', () {
        final singleMovieList = [
          Movie()..title = 'Single Movie'
        ];
        
        singleMovieList.sort((a, b) => b.created.compareTo(a.created));
        
        expect(singleMovieList, hasLength(1));
        expect(singleMovieList.first.title, equals('Single Movie'));
      });
    });

    group('Error Handling', () {
      test('should create KException with proper message', () {
        const errorMessage = 'Test error';
        final exception = KException('Failed to load movies: $errorMessage');
        
        expect(exception, isA<KException>());
        expect(exception.toString(), contains('Failed to load movies'));
        expect(exception.toString(), contains(errorMessage));
      });

      test('should handle various error types in exception creation', () {
        final testErrors = [
          'Database connection failed',
          'Network timeout',
          'Permission denied',
          '',
          'Very long error message that might exceed normal length limits',
        ];

        for (final error in testErrors) {
          final exception = KException('Failed to load movies: $error');
          expect(exception.toString(), contains('Failed to load movies'));
        }
      });
    });

    group('Provider Lifecycle', () {
      test('should handle provider disposal', () async {
        final testContainer = ProviderContainer();
        final notifier = testContainer.read(homeProvider.notifier);
        
        expect(notifier, isNotNull);
        
        testContainer.dispose();
        // After disposal, provider should be cleaned up
        expect(() => testContainer.read(homeProvider), throwsA(anything));
      });

      test('should maintain provider consistency', () async {
        final notifier1 = container.read(homeProvider.notifier);
        final notifier2 = container.read(homeProvider.notifier);
        
        // Should return the same instance
        expect(identical(notifier1, notifier2), isTrue);
      });
    });

    group('Movie List Operations', () {
      test('should handle large datasets efficiently', () {
        final largeMovieList = List.generate(1000, (index) => 
          Movie()
            ..title = 'Movie $index'
            ..description = 'Description $index'
            ..created = DateTime.now().subtract(Duration(days: index))
        );
        
        // Test sorting performance
        largeMovieList.sort((a, b) => b.created.compareTo(a.created));
        
        expect(largeMovieList, hasLength(1000));
        expect(largeMovieList.first.title, equals('Movie 0')); // Most recent
        expect(largeMovieList.last.title, equals('Movie 999')); // Oldest
      });

      test('should maintain data integrity during sorting', () {
        final movies = [
          Movie()..title = 'A'..created = DateTime(2023, 1, 1),
          Movie()..title = 'B'..created = DateTime(2023, 1, 2),
          Movie()..title = 'C'..created = DateTime(2023, 1, 3),
        ];
        
        final originalTitles = movies.map((m) => m.title).toSet();
        
        movies.sort((a, b) => b.created.compareTo(a.created));
        
        final sortedTitles = movies.map((m) => m.title).toSet();
        
        expect(sortedTitles, equals(originalTitles));
        expect(movies[0].title, equals('C'));
        expect(movies[2].title, equals('A'));
      });
    });
  });
}