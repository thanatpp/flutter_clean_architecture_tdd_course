import 'dart:convert';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test("should be a subclass of NumberTrivia entity", () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test("should return valid model when the json is an int", () {
      Map<String, dynamic> json = jsonDecode(fixture("trivia.json"));

      final actual = NumberTriviaModel.fromJson(json);

      expect(actual, tNumberTriviaModel);
    });

    test("should return valid model when the json is an double", () {
      Map<String, dynamic> json = jsonDecode(fixture("trivia_double.json"));

      final actual = NumberTriviaModel.fromJson(json);

      expect(actual, tNumberTriviaModel);
    });
  });

  group("toJson", () {
    test("should return a valid json map", () {
      var expected = {"text": "Test Text", "number": 1};

      final actual = tNumberTriviaModel.toJson();

      expect(actual, expected);
    });
  });
}
