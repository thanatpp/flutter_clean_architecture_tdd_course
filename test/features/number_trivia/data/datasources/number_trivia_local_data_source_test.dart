import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_reivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'number_trivia_local_data_source_test.mocks.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late SharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final tNumberTrivia =
        NumberTriviaModel.fromJson(jsonDecode(fixture("trivia_cache.json")));

    test(
        "should return NumberTrivia from SharedPreferences when found the data in the cache",
        () async {
      when(mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA))
          .thenReturn(fixture("trivia_cache.json"));

      final actual = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA));
      expect(actual, tNumberTrivia);
    });

    test("should throw CacheException when NumberTrivia is not found in cache",
        () async {
      when(mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA))
          .thenReturn(null);

      expect(() async => await dataSource.getLastNumberTrivia(),
          throwsA(const TypeMatcher<CacheException>()));
      verify(mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA));
    });
  });

  group("cacheNumberTrivia", () {
    test("should call SharedPreferences to cache the data", () {
      const tNumberTrivia = NumberTriviaModel(text: "Text Cache", number: 99);

      dataSource.cacheNumberTrivia(tNumberTrivia);

      verify(mockSharedPreferences.setString(
          CACHE_NUMBER_TRIVIA, json.encode(tNumberTrivia.toJson())));
    });
  });
}
