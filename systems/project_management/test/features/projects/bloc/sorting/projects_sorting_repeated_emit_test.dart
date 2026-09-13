import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/components/custom_drop_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/projects/bloc/sorting/projects_sorting_bloc.dart';
import 'package:project_management/features/projects/bloc/sorting/projects_sorting_events.dart';
import 'package:project_management/features/projects/bloc/sorting/projects_sorting_states.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

/// Regression tests for states that used to be empty and `const`.
///
/// Dart canonicalises identical `const` instances into one object, and
/// `Bloc.emit` skips a state that equals the current one. An empty
/// `const SortingOptionSelected()` emitted twice in a row therefore reached the
/// UI once, so picking a second option left the first one ticked.
void main() {
  late MockProjectsRepo mockRepo;
  late ProjectsSortingBloc bloc;

  final optionA = DropListModel(id: 1, name: 'Newest', key: '1');
  final optionB = DropListModel(id: 2, name: 'Oldest', key: '2');

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectsRepo();
    bloc = ProjectsSortingBloc(repo: mockRepo);
  });

  group('ProjectsSortingBloc repeated emits', () {
    blocTest<ProjectsSortingBloc, ProjectsSortingState>(
      'selecting a second option emits a second state carrying that option',
      build: () => bloc,
      act: (bloc) => bloc
        ..add(SelectSortingOption(arguments: optionA))
        ..add(SelectSortingOption(arguments: optionB)),
      expect: () => [
        isA<SortingOptionSelected>().having(
          (s) => s.selectedOption?.key,
          'selectedOption.key',
          '1',
        ),
        isA<SortingOptionSelected>().having(
          (s) => s.selectedOption?.key,
          'selectedOption.key',
          '2',
        ),
      ],
    );

    blocTest<ProjectsSortingBloc, ProjectsSortingState>(
      'applying the same option twice emits twice, so listeners refetch again',
      build: () => bloc,
      act: (bloc) => bloc
        ..add(SelectSortingOption(arguments: optionA))
        ..add(ApplySortingOption())
        ..add(ApplySortingOption()),
      expect: () => [
        isA<SortingOptionSelected>(),
        isA<SortingApplied>().having(
          (s) => s.appliedOption?.key,
          'appliedOption.key',
          '1',
        ),
        isA<SortingApplied>().having(
          (s) => s.appliedOption?.key,
          'appliedOption.key',
          '1',
        ),
      ],
    );
  });
}
