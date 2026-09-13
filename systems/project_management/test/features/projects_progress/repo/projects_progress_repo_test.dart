import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late ProjectProgressRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = ProjectProgressRepoImpl(network: mockNetwork);
  });

  group('ProjectProgressRepoImpl', () {
    group('getProjectProgress', () {
      test('returns ProjectsOverviewModel on success with correct endpoint and method', () async {
        final expectedModel = ProjectsOverviewModel.fromJson({
          'succeeded': true,
          'data': [
            {
              'name': 'On Track',
              'hexColor': '#4CAF50',
              'percentage': 60,
              'count': 12,
            },
          ],
        });

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

        final result = await repo.getProjectProgress();

        expect(result, isA<ProjectsOverviewModel>());
        expect(result.succeeded, isTrue);
        expect(result.data, hasLength(1));
        expect(result.data!.first.name, 'On Track');
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectProgress,
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });

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

        expect(() => repo.getProjectProgress(), throwsA(isA<NetworkException>()));
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectProgress,
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });
  });
}
