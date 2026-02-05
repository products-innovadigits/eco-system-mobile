import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/projects/bloc/sorting/projects_sorting_bloc.dart';
import 'package:project_management/features/projects/bloc/sorting/projects_sorting_events.dart';
import 'package:project_management/features/projects/bloc/sorting/projects_sorting_states.dart';
import 'package:project_management/features/projects/model/project_sorting_options_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';
import '../../../../helpers/fixture_reader.dart';

void main() {
  late MockProjectsRepo mockRepo;
  late ProjectsSortingBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectsRepo();
    bloc = ProjectsSortingBloc(repo: mockRepo);
  });

  tearDown(() {
  });

  group('ProjectsSortingBloc', () {
    group('LoadSortingOptions', () {
      blocTest<ProjectsSortingBloc, ProjectsSortingState>(
        'emits [SortingLoading, SortingOptionsLoaded] when repo returns success (fixture: contract tied to project_sorting_options_response.json)',
        build: () {
          final fixtureJson =
              readJsonFixture('projects/project_sorting_options_response.json');
          final model =
              ProjectSortingOptionsModel.fromJson(fixtureJson);
          when(() => mockRepo.getProjectSortingOptions()).thenAnswer(
            (_) async => model,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(LoadSortingOptions()),
        expect: () => [
          const SortingLoading(), 
          isA<SortingOptionsLoaded>(),
        ],
        verify: (bloc) {
          expect(bloc.sortingOptions, isNotEmpty, reason: 'Sorting options should be populated in the bloc after load');
          verify(() => mockRepo.getProjectSortingOptions()).called(1);
        },
      );

      blocTest<ProjectsSortingBloc, ProjectsSortingState>(
        'emits [SortingLoading, SortingError] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectSortingOptions(),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadSortingOptions()),
        expect: () => [
          const SortingLoading(), 
          isA<SortingError>(),
        ],
      );
    });
  });
}
