import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/utils/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>()
])
import 'number_trivia_bloc_test.mocks.dart';

void main() {
  late NumberTriviaBloc bloc;
  late GetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late GetRandomNumberTrivia mockGetRandomNumberTrivia;
  late InputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test("should be Empty state when initial state", () {
    expect(bloc.initialState, equals(Empty()));
  });

  group("GetTriviaForConcreteNumber", () {
    const tNumberString = "1";
    const tNumberPassed = 1;
    const tNumberTrivia = NumberTrivia(text: "Test trivia", number: 1);

    test(
      "should call the InputConverter to validate and convert to an unsigned integer",
      () async {
        when(mockInputConverter.stringToUnsignedInt(tNumberString))
            .thenReturn(Right(tNumberPassed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberPassed)))
            .thenAnswer((_) async => const Right(tNumberTrivia));

        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockInputConverter.stringToUnsignedInt(tNumberString));

        verify(mockInputConverter.stringToUnsignedInt(tNumberString));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input invalid',
      setUp: () => when(mockInputConverter.stringToUnsignedInt(tNumberString))
          .thenReturn(Left(InvalidInputFailure())),
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => <NumberTriviaState>[
        const Error(
            message:
                "Invalid Input - The number must be a positive integrate and Zero."),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when get data success',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInt(tNumberString))
            .thenReturn(Right(tNumberPassed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberPassed)))
            .thenAnswer((_) async => const Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          <NumberTriviaState>[Loading(), const Loaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when get data failed',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInt(tNumberString))
            .thenReturn(Right(tNumberPassed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberPassed)))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [Loading(), const Error(message: SERVER_FAILURE_MESSAGE)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with error message when get data failed',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInt(tNumberString))
            .thenReturn(Right(tNumberPassed));
        when(mockGetConcreteNumberTrivia(Params(number: tNumberPassed)))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group("GetRandomNumberTrivia", () {
    const tNumberTrivia = NumberTrivia(text: "Test trivia", number: 1);

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when get data success',
      setUp: () {
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () =>
          <NumberTriviaState>[Loading(), const Loaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when get data failed',
      setUp: () {
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), const Error(message: SERVER_FAILURE_MESSAGE)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with error message when get data failed',
      setUp: () {
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
