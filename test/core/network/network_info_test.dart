import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<InternetConnectionChecker>()])
import 'network_info_test.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late InternetConnectionChecker mockInternetChecker;

  setUp(() {
    mockInternetChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(connectionChecker: mockInternetChecker);
  });

  group("isConnected", () {
    test("should forward the call to InternetConnectionChecker.hasConnection",
        () async {
      final tIsConnected = Future.value(true);

      when(mockInternetChecker.hasConnection)
          .thenAnswer((_) => tIsConnected);

      final actual = networkInfoImpl.isConnected;

      expect(actual,tIsConnected);
    });
  });
}
