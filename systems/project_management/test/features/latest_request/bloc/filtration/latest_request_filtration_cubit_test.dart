import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/latest_request/bloc/filtration/latest_request_filtration_cubit.dart';
import 'package:project_management/features/latest_request/bloc/filtration/latest_request_filtration_state.dart';
import 'package:project_management/features/projects/model/projects_filters_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProjectsRepo mockRepo;
  late LatestRequestFiltrationCubit cubit;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectsRepo();
    cubit = LatestRequestFiltrationCubit(repo: mockRepo);
  });

  tearDown(() {
  });

  group('LatestRequestFiltrationCubit', () {
    group('loadFilterOptions', () {
      blocTest<LatestRequestFiltrationCubit, LatestRequestFiltrationState>(
        'emits [LatestRequestFiltrationLoading, LatestRequestFiltrationLoaded] when repo returns data',
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
          return cubit;
        },
        act: (cubit) => cubit.loadFilterOptions(),
        expect: () => [
          const LatestRequestFiltrationLoading(),
          isA<LatestRequestFiltrationLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjectFilterOptions()).called(1);
        },
      );

      blocTest<LatestRequestFiltrationCubit, LatestRequestFiltrationState>(
        'emits [LatestRequestFiltrationLoading, LatestRequestFiltrationFailure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectFilterOptions(),
          ).thenThrow(NetworkException('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.loadFilterOptions(),
        expect: () => [
          const LatestRequestFiltrationLoading(),
          isA<LatestRequestFiltrationFailure>(),
        ],
      );
    });
  });
}
