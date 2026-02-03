import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/latest_request/bloc/sorting/latest_request_sorting_cubit.dart';
import 'package:project_management/features/latest_request/bloc/sorting/latest_request_sorting_state.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

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
        'emits [LatestRequestSortingLoading, LatestRequestSortingOptionsLoaded] when repo returns success response',
        build: () {
          when(() => mockRepo.getProjectSortingOptions()).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {
                'data': [
                  {'id': 1, 'nameAr': 'Test Sort'},
                ],
              },
            ),
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
