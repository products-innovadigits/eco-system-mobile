import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/project_categories_progress/bloc/project_categories_progress_cubit.dart';
import 'package:project_management/features/project_categories_progress/bloc/project_categories_progress_state.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

void main() {
  late MockProjectCategoriesProgressRepo mockRepo;
  late ProjectCategoriesProgressCubit cubit;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectCategoriesProgressRepo();
    cubit = ProjectCategoriesProgressCubit(repo: mockRepo);
  });

  tearDown(() {
  });

  group('ProjectCategoriesProgressCubit', () {
    group('loadCategoriesProgress', () {
      blocTest<ProjectCategoriesProgressCubit, ProjectCategoriesProgressState>(
        'emits [Loading, Loaded] when repo returns success response',
        build: () {
          when(() => mockRepo.getProjectCategoriesProgress()).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {
                'data': [
                  {'id': 1, 'name': 'Category 1'},
                ],
              },
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadCategoriesProgress(),
        expect: () => [
          const ProjectCategoriesProgressLoading(),
          isA<ProjectCategoriesProgressLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjectCategoriesProgress()).called(1);
        },
      );

      blocTest<ProjectCategoriesProgressCubit, ProjectCategoriesProgressState>(
        'emits [Loading, Empty] when repo returns empty data',
        build: () {
          when(() => mockRepo.getProjectCategoriesProgress()).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'data': []},
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadCategoriesProgress(),
        expect: () => [
          const ProjectCategoriesProgressLoading(),
          isA<ProjectCategoriesProgressEmpty>(),
        ],
      );

      blocTest<ProjectCategoriesProgressCubit, ProjectCategoriesProgressState>(
        'emits [Loading, Failure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectCategoriesProgress(),
          ).thenThrow(NetworkException('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.loadCategoriesProgress(),
        expect: () => [
          const ProjectCategoriesProgressLoading(),
          isA<ProjectCategoriesProgressFailure>(),
        ],
      );
    });
  });
}
