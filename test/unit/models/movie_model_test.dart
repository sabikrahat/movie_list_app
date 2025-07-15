import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_list_app/src/features/home/model/movie_model.dart';

void main() {
  group('Movie Model Tests', () {
    late Movie testMovie;
    
    setUp(() {
      testMovie = Movie()
        ..title = 'Test Movie'
        ..description = 'Test Description'
        ..isFavorite = true;
    });

    group('Constructor and ID Generation', () {
      test('should generate unique ID on creation', () {
        final movie1 = Movie();
        final movie2 = Movie();
        
        expect(movie1.id, isNotEmpty);
        expect(movie2.id, isNotEmpty);
        expect(movie1.id, isNot(equals(movie2.id)));
      });

      test('should set default values correctly', () {
        final movie = Movie();
        
        expect(movie.isFavorite, isFalse);
        expect(movie.created, isA<DateTime>());
        expect(movie.updated, isA<DateTime>());
        expect(movie.id, isNotEmpty);
      });

      test('should generate ID based on microsecondsSinceEpoch', () {
        final movie = Movie();
        final idAsInt = int.parse(movie.id);
        final now = DateTime.now().microsecondsSinceEpoch;
        
        expect(idAsInt, greaterThan(now - 1000000)); // Within 1 second
      });
    });

    group('CopyWith Method', () {
      test('should preserve original ID when copying', () {
        final originalId = testMovie.id;
        final copiedMovie = testMovie.copyWith(title: 'New Title');
        
        expect(copiedMovie.id, equals(originalId));
      });

      test('should update specified fields only', () {
        final newTitle = 'Updated Title';
        final newDateTime = DateTime(2023, 1, 1);
        
        final copiedMovie = testMovie.copyWith(
          title: newTitle,
          updated: newDateTime,
        );
        
        expect(copiedMovie.title, equals(newTitle));
        expect(copiedMovie.description, equals(testMovie.description));
        expect(copiedMovie.isFavorite, equals(testMovie.isFavorite));
        expect(copiedMovie.updated, equals(newDateTime));
        expect(copiedMovie.created, equals(testMovie.created));
      });

      test('should preserve all fields when no parameters provided', () {
        final copiedMovie = testMovie.copyWith();
        
        expect(copiedMovie.id, equals(testMovie.id));
        expect(copiedMovie.title, equals(testMovie.title));
        expect(copiedMovie.description, equals(testMovie.description));
        expect(copiedMovie.isFavorite, equals(testMovie.isFavorite));
        expect(copiedMovie.created, equals(testMovie.created));
        expect(copiedMovie.updated, equals(testMovie.updated));
      });

      test('should toggle favorite status correctly', () {
        final originalFavorite = testMovie.isFavorite;
        final copiedMovie = testMovie.copyWith(isFavorite: !originalFavorite);
        
        expect(copiedMovie.isFavorite, equals(!originalFavorite));
        expect(testMovie.isFavorite, equals(originalFavorite)); // Original unchanged
      });
    });

    group('JSON Serialization', () {
      test('should convert to JSON correctly', () {
        final json = testMovie.toJson();
        
        expect(json['id'], equals(testMovie.id));
        expect(json['title'], equals(testMovie.title));
        expect(json['description'], equals(testMovie.description));
        expect(json['is_favorite'], equals(testMovie.isFavorite));
        expect(json['created'], equals(testMovie.created.toIso8601String()));
        expect(json['updated'], equals(testMovie.updated.toIso8601String()));
      });

      test('should convert from JSON correctly', () {
        final json = testMovie.toJson();
        final movieFromJson = Movie.fromJson(json);
        
        expect(movieFromJson.id, equals(testMovie.id));
        expect(movieFromJson.title, equals(testMovie.title));
        expect(movieFromJson.description, equals(testMovie.description));
        expect(movieFromJson.isFavorite, equals(testMovie.isFavorite));
        expect(movieFromJson.created, equals(testMovie.created));
        expect(movieFromJson.updated, equals(testMovie.updated));
      });

      test('should handle JSON with missing isFavorite field', () {
        final json = testMovie.toJson();
        json.remove('is_favorite');
        
        final movieFromJson = Movie.fromJson(json);
        
        expect(movieFromJson.isFavorite, isFalse); // Default value
      });

      test('should convert to raw JSON string correctly', () {
        final rawJson = testMovie.toRawJson();
        final decodedJson = jsonDecode(rawJson);
        
        expect(decodedJson, isA<Map<String, dynamic>>());
        expect(decodedJson['title'], equals(testMovie.title));
      });

      test('should convert from raw JSON string correctly', () {
        final rawJson = testMovie.toRawJson();
        final movieFromRawJson = Movie.fromRawJson(rawJson);
        
        expect(movieFromRawJson.id, equals(testMovie.id));
        expect(movieFromRawJson.title, equals(testMovie.title));
      });

      test('should throw error for malformed JSON', () {
        expect(
          () => Movie.fromRawJson('invalid json'),
          throwsA(isA<FormatException>()),
        );
      });

      test('should handle JSON with null values gracefully', () {
        final json = {
          'id': testMovie.id,
          'title': testMovie.title,
          'description': testMovie.description,
          'is_favorite': null,
          'created': testMovie.created.toIso8601String(),
          'updated': testMovie.updated.toIso8601String(),
        };
        
        final movieFromJson = Movie.fromJson(json);
        expect(movieFromJson.isFavorite, isFalse);
      });
    });

    group('JSON List Operations', () {
      late List<Movie> testMovies;
      
      setUp(() {
        testMovies = [
          Movie()..title = 'Movie 1'..description = 'Desc 1',
          Movie()..title = 'Movie 2'..description = 'Desc 2',
          Movie()..title = 'Movie 3'..description = 'Desc 3',
        ];
      });

      test('should convert list to JSON correctly', () {
        final jsonList = Movie.toJsonList(testMovies);
        
        expect(jsonList, hasLength(3));
        expect(jsonList[0]['title'], equals('Movie 1'));
        expect(jsonList[1]['title'], equals('Movie 2'));
        expect(jsonList[2]['title'], equals('Movie 3'));
      });

      test('should convert list from JSON correctly', () {
        final jsonList = Movie.toJsonList(testMovies);
        final moviesFromJson = Movie.fromJsonList(jsonList);
        
        expect(moviesFromJson, hasLength(3));
        expect(moviesFromJson[0].title, equals('Movie 1'));
        expect(moviesFromJson[1].title, equals('Movie 2'));
        expect(moviesFromJson[2].title, equals('Movie 3'));
      });

      test('should convert list to raw JSON string correctly', () {
        final rawJsonList = Movie.toRawJsonList(testMovies);
        final decodedList = jsonDecode(rawJsonList);
        
        expect(decodedList, isA<List>());
        expect(decodedList, hasLength(3));
      });

      test('should convert list from raw JSON string correctly', () {
        final rawJsonList = Movie.toRawJsonList(testMovies);
        final moviesFromRawJson = Movie.fromRawJsonList(rawJsonList);
        
        expect(moviesFromRawJson, hasLength(3));
        expect(moviesFromRawJson[0].title, equals('Movie 1'));
      });

      test('should handle empty list', () {
        final emptyList = <Movie>[];
        final jsonList = Movie.toJsonList(emptyList);
        final moviesFromJson = Movie.fromJsonList(jsonList);
        
        expect(jsonList, isEmpty);
        expect(moviesFromJson, isEmpty);
      });
    });

    group('Equality and Hash Code', () {
      test('should be equal when IDs match', () {
        final movie1 = Movie()..title = 'Title 1';
        final movie2 = Movie()..title = 'Title 2';
        movie2.id = movie1.id; // Set same ID
        
        expect(movie1, equals(movie2));
        expect(movie1.hashCode, equals(movie2.hashCode));
      });

      test('should not be equal when IDs differ', () {
        final movie1 = Movie()..title = 'Same Title';
        final movie2 = Movie()..title = 'Same Title';
        
        expect(movie1, isNot(equals(movie2)));
        expect(movie1.hashCode, isNot(equals(movie2.hashCode)));
      });

      test('should be identical to self', () {
        expect(testMovie, equals(testMovie));
        expect(testMovie.hashCode, equals(testMovie.hashCode));
      });

      test('should not be equal to different type', () {
        expect(testMovie, isNot(equals('not a movie')));
        expect(testMovie, isNot(equals(42)));
      });
    });

    group('String Representation', () {
      test('toString should return raw JSON', () {
        final stringRep = testMovie.toString();
        final fromString = Movie.fromRawJson(stringRep);
        
        expect(fromString.id, equals(testMovie.id));
        expect(fromString.title, equals(testMovie.title));
      });
    });

    group('DateTime Handling', () {
      test('should preserve DateTime precision in JSON conversion', () {
        final originalDateTime = DateTime.now();
        final movie = Movie()
          ..title = 'Test'
          ..description = 'Test'
          ..created = originalDateTime
          ..updated = originalDateTime;
        
        final json = movie.toJson();
        final movieFromJson = Movie.fromJson(json);
        
        expect(movieFromJson.created.toIso8601String(), 
               equals(originalDateTime.toIso8601String()));
        expect(movieFromJson.updated.toIso8601String(), 
               equals(originalDateTime.toIso8601String()));
      });

      test('should handle different DateTime formats', () {
        final dateTime = DateTime(2023, 12, 25, 10, 30, 45, 123, 456);
        final movie = Movie()
          ..title = 'Test'
          ..description = 'Test'
          ..created = dateTime;
        
        final json = movie.toJson();
        final movieFromJson = Movie.fromJson(json);
        
        expect(movieFromJson.created.year, equals(2023));
        expect(movieFromJson.created.month, equals(12));
        expect(movieFromJson.created.day, equals(25));
      });
    });

    group('Edge Cases', () {
      test('should handle very long strings', () {
        final longString = 'A' * 10000;
        final movie = Movie()
          ..title = longString
          ..description = longString;
        
        final json = movie.toJson();
        final movieFromJson = Movie.fromJson(json);
        
        expect(movieFromJson.title, equals(longString));
        expect(movieFromJson.description, equals(longString));
      });

      test('should handle special characters in strings', () {
        final specialString = 'Title with 特殊字符 and émojis 🎬🍿';
        final movie = Movie()
          ..title = specialString
          ..description = specialString;
        
        final json = movie.toJson();
        final movieFromJson = Movie.fromJson(json);
        
        expect(movieFromJson.title, equals(specialString));
        expect(movieFromJson.description, equals(specialString));
      });

      test('should handle empty strings', () {
        final movie = Movie()
          ..title = ''
          ..description = '';
        
        final json = movie.toJson();
        final movieFromJson = Movie.fromJson(json);
        
        expect(movieFromJson.title, isEmpty);
        expect(movieFromJson.description, isEmpty);
      });

      test('should maintain object integrity through multiple conversions', () {
        final originalMovie = testMovie;
        
        // Convert through multiple formats
        final json = originalMovie.toJson();
        final rawJson = originalMovie.toRawJson();
        final movieFromJson = Movie.fromJson(json);
        final movieFromRawJson = Movie.fromRawJson(rawJson);
        
        // All should be equal
        expect(movieFromJson, equals(originalMovie));
        expect(movieFromRawJson, equals(originalMovie));
        expect(movieFromJson, equals(movieFromRawJson));
      });
    });
  });
}