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
  late ProjectDetailsRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = ProjectDetailsRepoImpl(network: mockNetwork);
  });

  group('ProjectDetailsRepoImpl', () {
    group('getProjectDetails', () {
      test(
        'returns dynamic on success with correct endpoint and method',
        () async {
          final expectedData = {'id': 1, 'title': 'Test Project'};
          const testId = 1;

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

          final result = await repo.getProjectDetails(testId);

          expect(result, expectedData);
          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.projectDetails(testId),
              method: ServerMethods.GET,
            ),
          ).called(1);
        },
      );

      test('throws NetworkException on error', () async {
        const testId = 1;

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
          () => repo.getProjectDetails(testId),
          throwsA(isA<NetworkException>()),
        );
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectDetails(testId),
            method: ServerMethods.GET,
          ),
        ).called(1);
      });
    });
  });
}
