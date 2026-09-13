import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/project_categories_progress/bloc/project_categories_progress_cubit.dart';
import 'package:project_management/features/project_categories_progress/bloc/project_categories_progress_state.dart';
import 'package:project_management/features/project_categories_progress/model/project_categories_progress_response_model.dart';

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
            (_) async => ProjectCategoriesProgressResponseModel.fromJson({
              'succeeded': true,
              'data': {
                'categories': [
                  {
                    'id': 1,
                    'name': 'Category 1',
                    'progress': 75.0,
                    'color': '#2196F3',
                  },
                ],
              },
            }),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadCategoriesProgress(),
        expect: () => [
          const ProjectCategoriesProgressLoading(),
          isA<ProjectCategoriesProgressLoaded>()
              .having((s) => s.categories.length, 'categories.length', 1)
              .having((s) => s.categories.first.id, 'categories.first.id', 1)
              .having(
                (s) => s.categories.first.name,
                'categories.first.name',
                'Category 1',
              )
              .having(
                (s) => s.categories.first.progress,
                'categories.first.progress',
                75.0,
              ),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjectCategoriesProgress()).called(1);
        },
      );

      blocTest<ProjectCategoriesProgressCubit, ProjectCategoriesProgressState>(
        'emits [Loading, Empty] when repo returns empty data',
        build: () {
          when(() => mockRepo.getProjectCategoriesProgress()).thenAnswer(
            (_) async => ProjectCategoriesProgressResponseModel.fromJson({
              'succeeded': true,
              'data': {'categories': <dynamic>[]},
            }),
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
