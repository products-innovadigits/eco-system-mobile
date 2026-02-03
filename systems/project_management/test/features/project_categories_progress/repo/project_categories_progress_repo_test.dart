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
  late ProjectCategoriesProgressRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = ProjectCategoriesProgressRepoImpl(network: mockNetwork);
  });

  group('ProjectCategoriesProgressRepoImpl', () {
    group('getProjectCategoriesProgress', () {
      test(
        'returns dynamic on success with correct endpoint and method',
        () async {
          final expectedData = {'categories': []};

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
          ).thenAnswer((_) async => expectedData);

          final result = await repo.getProjectCategoriesProgress();

          expect(result, expectedData);
          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.projectCategoriesProgress,
              method: ServerMethods.GET,
            ),
          ).called(1);
        },
      );

      test('throws NetworkException on error', () async {
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
          () => repo.getProjectCategoriesProgress(),
          throwsA(isA<NetworkException>()),
        );
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectCategoriesProgress,
            method: ServerMethods.GET,
          ),
        ).called(1);
      });
    });
  });
}
