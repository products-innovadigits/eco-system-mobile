import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/latest_request/bloc/sorting/latest_request_sorting_cubit.dart';
import 'package:project_management/features/latest_request/bloc/sorting/latest_request_sorting_state.dart';
import 'package:project_management/features/projects/model/project_sorting_options_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';
import '../../../../helpers/fixture_reader.dart';

void main() {
  late MockProjectsRepo mockRepo;
  late LatestRequestSortingCubit cubit;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectsRepo();
    cubit = LatestRequestSortingCubit(repo: mockRepo);
  });

  tearDown(() {
  });

  group('LatestRequestSortingCubit', () {
    group('loadSortingOptions', () {
      blocTest<LatestRequestSortingCubit, LatestRequestSortingState>(
        'emits [LatestRequestSortingLoading, LatestRequestSortingOptionsLoaded] when repo returns success (fixture: contract tied to project_sorting_options_response.json)',
        build: () {
          final fixtureJson =
              readJsonFixture('projects/project_sorting_options_response.json');
          final model = ProjectSortingOptionsModel.fromJson(fixtureJson);
          when(() => mockRepo.getProjectSortingOptions()).thenAnswer(
            (_) async => model,
          );
          return cubit;
        },
        act: (cubit) => cubit.loadSortingOptions(),
        expect: () => [
          const LatestRequestSortingLoading(),
          isA<LatestRequestSortingOptionsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjectSortingOptions()).called(1);
        },
      );

      blocTest<LatestRequestSortingCubit, LatestRequestSortingState>(
        'emits [LatestRequestSortingLoading, LatestRequestSortingError] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectSortingOptions(),
          ).thenThrow(NetworkException('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.loadSortingOptions(),
        expect: () => [
          const LatestRequestSortingLoading(),
          isA<LatestRequestSortingError>(),
        ],
      );
    });
  });
}
