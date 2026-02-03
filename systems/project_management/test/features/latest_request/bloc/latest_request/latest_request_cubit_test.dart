import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/pms_exports.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockLatestRequestRepo mockRepo;
  late LatestRequestCubit cubit;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockLatestRequestRepo();
    cubit = LatestRequestCubit(repo: mockRepo);
  });

  // tearDown(() {
  // });

  group('LatestRequestCubit', () {
    group('getLatestRequest', () {
      blocTest<LatestRequestCubit, LatestRequestState>(
        'emits [Loading, Loaded] when repo returns data',
        build: () {
          when(() => mockRepo.getLatestRequest(any())).thenAnswer(
            (_) async => LatestRequestModel(
              succeeded: true,
              data: [LatestRequestItem(id: 1)],
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.getLatestRequest(),
        expect: () => [
          const LatestRequestLoading(),
          isA<LatestRequestLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getLatestRequest(any())).called(1);
        },
      );

      blocTest<LatestRequestCubit, LatestRequestState>(
        'emits [Loading, Empty] when repo returns empty data',
        build: () {
          when(() => mockRepo.getLatestRequest(any())).thenAnswer(
            (_) async => LatestRequestModel(succeeded: true, data: []),
          );
          return cubit;
        },
        act: (cubit) => cubit.getLatestRequest(),
        expect: () => [const LatestRequestLoading(), isA<LatestRequestEmpty>()],
      );

      blocTest<LatestRequestCubit, LatestRequestState>(
        'emits [Loading, Failure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getLatestRequest(any()),
          ).thenThrow(NetworkException('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.getLatestRequest(),
        expect: () => [
          const LatestRequestLoading(),
          isA<LatestRequestFailure>(),
        ],
      );
    });
  });
}
