import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'number_trivia_remote_data_source_test.mocks.dart';

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late http.Client mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    final tNumberTrivia =
        NumberTriviaModel.fromJson(jsonDecode(fixture("trivia.json")));

    test('''should perform a GET request on a url
    begin the endpoint with a application/json header''', () {
      final uri = Uri.parse('http://numberapi.com/$tNumber');

      when(mockClient.get(Uri.parse('http://numberapi.com/$tNumber'),
              headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(
          mockClient.get(uri, headers: {"Content-type": "application/json"}));
    });

    test("should return NumberTrivia when the response is 200", () async {
      when(mockClient.get(Uri.parse('http://numberapi.com/$tNumber'),
              headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));

      final actual = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(actual, equals(tNumberTrivia));
    });

    test("should return ServerException when the response is not 200",
        () async {
      when(mockClient.get(Uri.parse('http://numberapi.com/$tNumber'),
              headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response("Internal Server Error", 500));

      expect(() async => await dataSource.getConcreteNumberTrivia(tNumber),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTrivia =
        NumberTriviaModel.fromJson(jsonDecode(fixture("trivia.json")));
    final tUri = Uri.parse('http://numberapi.com/random');

    test('''should perform a GET request on a url
    begin the endpoint with a application/json header''', () {
      when(mockClient.get(tUri, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));

      dataSource.getRandomNumberTrivia();

      verify(
          mockClient.get(tUri, headers: {"Content-type": "application/json"}));
    });

    test("should return NumberTrivia when the response is 200", () async {
      when(mockClient.get(tUri, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));

      final actual = await dataSource.getRandomNumberTrivia();

      expect(actual, equals(tNumberTrivia));
    });

    test("should return ServerException when the response is not 200",
        () async {
      when(mockClient.get(tUri, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response("Internal Server Error", 500));

      expect(() async => await dataSource.getRandomNumberTrivia(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
