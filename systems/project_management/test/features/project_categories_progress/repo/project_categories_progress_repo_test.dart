import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/project_categories_progress/model/project_categories_progress_response_model.dart';

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
      test('returns ProjectCategoriesProgressResponseModel on success with correct endpoint and method', () async {
        final expectedModel = ProjectCategoriesProgressResponseModel.fromJson({
          'succeeded': true,
          'data': {
            'categories': [
              {
                'id': 1,
                'name': 'Category A',
                'progress': 75.0,
                'color': '#2196F3',
              },
            ],
          },
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

        final result = await repo.getProjectCategoriesProgress();

        expect(result, isA<ProjectCategoriesProgressResponseModel>());
        expect(result.succeeded, isTrue);
        expect(result.categories, hasLength(1));
        expect(result.categories.first.name, 'Category A');
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectCategoriesProgress,
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

        expect(() => repo.getProjectCategoriesProgress(), throwsA(isA<NetworkException>()));
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectCategoriesProgress,
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });
  });
}
