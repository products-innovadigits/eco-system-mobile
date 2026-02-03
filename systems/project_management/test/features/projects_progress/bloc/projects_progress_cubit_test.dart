import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/projects_progress/bloc/projects_progress_cubit.dart';
import 'package:project_management/features/projects_progress/bloc/projects_progress_state.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

void main() {
  late MockProjectProgressRepo mockRepo;
  late ProjectsProgressCubit cubit;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectProgressRepo();
    cubit = ProjectsProgressCubit(repo: mockRepo);
  });

  tearDown(() {
  });

  group('ProjectsProgressCubit', () {
    group('loadProjectsProgress', () {
      blocTest<ProjectsProgressCubit, ProjectsProgressState>(
        'emits [Loading, Loaded] when repo returns success response',
        build: () {
          when(() => mockRepo.getProjectProgress()).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {
                'data': [
                  {'name': 'Project 1', 'count': 10},
                ],
              },
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadProjectsProgress(),
        expect: () => [
          const ProjectsProgressLoading(),
          isA<ProjectsProgressLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjectProgress()).called(1);
        },
      );

      blocTest<ProjectsProgressCubit, ProjectsProgressState>(
        'emits [Loading, Empty] when repo returns empty data',
        build: () {
          when(() => mockRepo.getProjectProgress()).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'data': []},
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadProjectsProgress(),
        expect: () => [
          const ProjectsProgressLoading(),
          isA<ProjectsProgressEmpty>(),
        ],
      );

      blocTest<ProjectsProgressCubit, ProjectsProgressState>(
        'emits [Loading, Failure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectProgress(),
          ).thenThrow(NetworkException('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.loadProjectsProgress(),
        expect: () => [
          const ProjectsProgressLoading(),
          isA<ProjectsProgressFailure>(),
        ],
      );
    });
  });
}
