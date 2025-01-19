import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const BASE_URI = "http://numberapi.com/";

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final uri = Uri.parse("$BASE_URI$number");
    return _getTriviaFromUri(uri);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final uri = Uri.parse("${BASE_URI}random");
    return _getTriviaFromUri(uri);
  }

  Future<NumberTriviaModel> _getTriviaFromUri(Uri uri) async {
    try {
      final response =
      await client.get(uri, headers: {"Content-type": "application/json"});
      if (response.statusCode == 200) {
        return NumberTriviaModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException();
      }
    } catch (err) {
      print(err);
      throw ServerException();
    }
  }
}
