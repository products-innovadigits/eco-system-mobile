import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/projects/bloc/filtration/projects_filter_provider.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

class MockProjectsFilterProvider extends Mock implements ProjectsFilterProvider {}

void main() {
  late MockProjectsRepo mockRepo;
  late MockProjectsFilterProvider mockFilterProvider;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectsRepo();
    mockFilterProvider = MockProjectsFilterProvider();
    when(() => mockFilterProvider.getFilterParams()).thenReturn({});
  });

  tearDown(() {
  });

  group('ProjectsBloc', () {
    group('LoadProjects', () {
      blocTest<ProjectsBloc, ProjectsState>(
        'emits [ProjectsLoading, ProjectsLoaded] when repo returns data',
        build: () {
          when(() => mockRepo.getProjects(any())).thenAnswer(
            (_) async => ProjectsModel(
              succeeded: true,
              data: ProjectsDataModel(
                items: [ProjectDetailsModel(id: 1, title: 'Test Project')],
                currentPage: 1,
                totalPages: 1,
                totalCount: 1,
              ),
            ),
          );
          return ProjectsBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) => bloc.add(LoadProjects(searchEngine: SearchEngine())),
        expect: () => [isA<ProjectsLoading>(), isA<ProjectsLoaded>()],
        verify: (_) {
          verify(() => mockRepo.getProjects(any())).called(1);
        },
      );

      blocTest<ProjectsBloc, ProjectsState>(
        'emits [ProjectsLoading, ProjectsEmpty] when repo returns empty data',
        build: () {
          when(() => mockRepo.getProjects(any())).thenAnswer(
            (_) async => ProjectsModel(
              succeeded: true,
              data: ProjectsDataModel(items: []),
            ),
          );
          return ProjectsBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) => bloc.add(LoadProjects(searchEngine: SearchEngine())),
        expect: () => [isA<ProjectsLoading>(), isA<ProjectsEmpty>()],
      );
    });

    group('SearchChanged', () {
      blocTest<ProjectsBloc, ProjectsState>(
        'triggers LoadProjects and repo called with searchKeyword',
        build: () {
          when(() => mockRepo.getProjects(any())).thenAnswer(
            (_) async => ProjectsModel(
              succeeded: true,
              data: ProjectsDataModel(items: []),
            ),
          );
          return ProjectsBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) => bloc.add(const SearchChanged('test query')),
        expect: () => [isA<ProjectsLoading>(), isA<ProjectsEmpty>()],
        verify: (_) {
          final result = verify(() => mockRepo.getProjects(captureAny())).captured;
          expect(result, isNotEmpty, reason: 'repo.getProjects was not called');
          
          final engine = result.first as SearchEngine;
          expect(engine.query['searchKeyword'], equals('test query'), 
              reason: 'SearchKeyword mismatch in SearchEngine query. Expected "test query", got ${engine.query['searchKeyword']}');
        },
      );
    });

    group('LoadMoreProjects', () {
      blocTest<ProjectsBloc, ProjectsState>(
        'triggers next page call when hasMorePages is true',
        build: () {
          when(() => mockRepo.getProjects(any())).thenAnswer(
            (_) async => ProjectsModel(
              succeeded: true,
              data: ProjectsDataModel(
                items: [ProjectDetailsModel(id: 1)],
                currentPage: 1,
                totalPages: 2,
                totalCount: 10,
              ),
            ),
          );
          return ProjectsBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) {
          bloc.add(LoadProjects(searchEngine: SearchEngine()));
          bloc.add(const LoadMoreProjects());
        },
        skip: 2, // Skip initial loading/loaded states
        expect: () => [
          isA<ProjectsLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
          isA<ProjectsLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjects(any())).called(2);
        },
      );

      blocTest<ProjectsBloc, ProjectsState>(
        'does nothing when hasMorePages is false',
        build: () {
          when(() => mockRepo.getProjects(any())).thenAnswer(
            (_) async => ProjectsModel(
              succeeded: true,
              data: ProjectsDataModel(
                items: [ProjectDetailsModel(id: 1)],
                currentPage: 1,
                totalPages: 1,
                totalCount: 1,
              ),
            ),
          );
          return ProjectsBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) {
          bloc.add(LoadProjects(searchEngine: SearchEngine()));
          bloc.add(const LoadMoreProjects());
        },
        skip: 2,
        expect: () => [],
        verify: (_) {
          verify(() => mockRepo.getProjects(any())).called(1);
        },
      );
    });
  });
}
