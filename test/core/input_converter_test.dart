import 'dart:ffi';

import 'package:clean_architecture_tdd_course/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInt", () {
    test("should return integer when the string is present an unsigned integer",
        () {
      final actual = inputConverter.stringToUnsignedInt("123");

      expect(actual, const Right(123));
    });

    test("should return InvalidInputException when the string is not integer",
        () {
      final actual = inputConverter.stringToUnsignedInt("abc");

      expect(actual, Left(InvalidInputFailure()));
    });

    test("should return InvalidInputException when the string is negative integer",
            () {
          final actual = inputConverter.stringToUnsignedInt("-11");

          expect(actual, Left(InvalidInputFailure()));
        });
  });
}
