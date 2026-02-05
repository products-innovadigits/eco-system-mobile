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
  late ProjectsRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = ProjectsRepoImpl(network: mockNetwork);
  });

  group('ProjectsRepoImpl', () {
    group('getProjects', () {
      test(
        'returns ProjectsModel on success with correct endpoint and method',
        () async {
          final expectedModel = ProjectsModel(succeeded: true);
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

          final result = await repo.getProjects(searchEngine);

          expect(result, isNotNull, reason: 'repo.getProjects returned null unexpectedly');
          expect(result, isA<ProjectsModel>(), 
              reason: 'Expected ProjectsModel, got ${result.runtimeType}');
          expect(result.succeeded, isTrue, 
              reason: 'Expected ProjectsModel.succeeded to be true as returned by network');
          
          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.projects,
              query: any(named: 'query'),
              method: ServerMethods.POST,
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
          () => repo.getProjects(searchEngine),
          throwsA(isA<NetworkException>()),
          reason: 'Expected getProjects to rethrow NetworkException from network layer',
        );
        
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projects,
            query: any(named: 'query'),
            method: ServerMethods.POST,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('getProjectFilterOptions', () {
      test(
        'returns ProjectsFiltersModel on success with correct endpoint and method',
        () async {
          final expectedModel = ProjectsFiltersModel(succeeded: true);

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

          final result = await repo.getProjectFilterOptions();

          expect(result, isNotNull, reason: 'repo.getProjectFilterOptions returned null unexpectedly');
          expect(result, isA<ProjectsFiltersModel>(), 
              reason: 'Expected ProjectsFiltersModel, got ${result.runtimeType}');
          expect(result.succeeded, isTrue, 
              reason: 'Expected ProjectsFiltersModel.succeeded to be true');
          
          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.projectFilterOptions,
              method: ServerMethods.GET,
              model: any(named: 'model'),
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
          () => repo.getProjectFilterOptions(),
          throwsA(isA<NetworkException>()),
          reason: 'Expected getProjectFilterOptions to rethrow NetworkException',
        );
        
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectFilterOptions,
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('getProjectSortingOptions', () {
      test(
        'returns ProjectSortingOptionsModel on success with correct endpoint and method',
        () async {
          final expectedModel = ProjectSortingOptionsModel(
            succeeded: true,
            data: [
              ProjectSortingOptionModel(id: 1, nameAr: 'أ', nameEn: 'A'),
            ],
          );

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

          final result = await repo.getProjectSortingOptions();

          expect(result, isNotNull,
              reason: 'repo.getProjectSortingOptions returned null unexpectedly');
          expect(result, isA<ProjectSortingOptionsModel>(),
              reason: 'Expected ProjectSortingOptionsModel, got ${result.runtimeType}');
          expect(result.succeeded, isTrue,
              reason: 'Expected ProjectSortingOptionsModel.succeeded to be true');
          expect(result.data, isNotEmpty);

          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.projectSortingOptions,
              method: ServerMethods.GET,
              model: any(named: 'model'),
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
          () => repo.getProjectSortingOptions(),
          throwsA(isA<NetworkException>()),
          reason: 'Expected getProjectSortingOptions to rethrow NetworkException',
        );

        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectSortingOptions,
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });
  });
}
