import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/pms_exports.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late LatestRequestRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = LatestRequestRepoImpl(network: mockNetwork);
  });

  group('LatestRequestRepoImpl', () {
    group('getLatestRequest', () {
      test(
        'returns LatestRequestModel on success with correct endpoint and method',
        () async {
          final expectedModel = LatestRequestModel(succeeded: true);
          final searchEngine = SearchEngine();

          when(
            () => mockNetwork.requestOrThrow(
              any(),
              body: any(named: 'body'),
              baseUrl: any(named: 'baseUrl'),
              systemTypeEnum: any(named: 'systemTypeEnum'),
              model: any(named: 'model'),
              query: any(named: 'query'),
              header: any(named: 'header'),
              method: any(named: 'method'),
            ),
          ).thenAnswer((_) async => expectedModel);

          final result = await repo.getLatestRequest(searchEngine);

          expect(result, isA<LatestRequestModel>());
          expect(result.succeeded, true);
          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.latestRequest,
              query: any(named: 'query'),
              method: ServerMethods.GET,
              model: any(named: 'model'),
            ),
          ).called(1);
        },
      );

      test('throws NetworkException on error', () async {
        final searchEngine = SearchEngine();

        when(
          () => mockNetwork.requestOrThrow(
            any(),
            body: any(named: 'body'),
            baseUrl: any(named: 'baseUrl'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
            query: any(named: 'query'),
            header: any(named: 'header'),
            method: any(named: 'method'),
          ),
        ).thenThrow(NetworkException('Network error'));

        expect(
          () => repo.getLatestRequest(searchEngine),
          throwsA(isA<NetworkException>()),
        );
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.latestRequest,
            query: any(named: 'query'),
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });
  });
}
