import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/projects/bloc/filtration/projects_filtration_bloc.dart';
import 'package:project_management/features/projects/bloc/filtration/projects_filtration_events.dart';
import 'package:project_management/features/projects/bloc/filtration/projects_filtration_state.dart';
import 'package:project_management/features/projects/model/projects_filters_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProjectsRepo mockRepo;
  late ProjectsFiltrationBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectsRepo();
    bloc = ProjectsFiltrationBloc(repo: mockRepo);
  });

  tearDown(() {
  });

  group('ProjectsFiltrationBloc', () {
    group('LoadProjectsFilterOptions', () {
      blocTest<ProjectsFiltrationBloc, ProjectsFiltrationState>(
        'emits [ProjectsFiltrationLoading, ProjectsFiltrationLoaded] when repo returns data',
        build: () {
          when(() => mockRepo.getProjectFilterOptions()).thenAnswer(
            (_) async => ProjectsFiltersModel(
              succeeded: true,
              data: ProjectsFiltersData(
                categories: [],
                priorities: [],
                risks: [],
                statuses: [],
              ),
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadProjectsFilterOptions()),
        expect: () => [
          const ProjectsFiltrationLoading(),
          isA<ProjectsFiltrationLoaded>().having(
            (s) => s.filterOptions, 
            'filterOptions', 
            isNotNull,
          ),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjectFilterOptions()).called(1);
        },
      );

      blocTest<ProjectsFiltrationBloc, ProjectsFiltrationState>(
        'emits [ProjectsFiltrationLoading, ProjectsFiltrationFailure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectFilterOptions(),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadProjectsFilterOptions()),
        expect: () => [
          const ProjectsFiltrationLoading(),
          isA<ProjectsFiltrationFailure>().having(
            (s) => s.message, 
            'message', 
            isNotNull,
          ),
        ],
      );
    });
  });
}
