import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_bloc.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_events.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_states.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

void main() {
  late MockCycleReviewRepo mockRepo;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockCycleReviewRepo();
  });

  group('CycleReviewBloc', () {
    group('LoadCycleReview', () {
      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits [CycleReviewLoading, CycleReviewLoaded] when repo returns data',
        build: () {
          when(() => mockRepo.getCycleDetail(any())).thenAnswer(
            (_) async => CycleDetailModel(
              succeeded: true,
              data: CycleDetailDataModel(
                id: 1,
                title: 'Test Review',
                status: 'Active',
                overallProgress: 60,
              ),
            ),
          );
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadCycleReview(cycleId: 1)),
        expect: () => [isA<CycleReviewLoading>(), isA<CycleReviewLoaded>()],
        verify: (_) {
          verify(() => mockRepo.getCycleDetail(1)).called(1);
        },
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'CycleReviewLoaded contains correct detail data',
        build: () {
          when(() => mockRepo.getCycleDetail(any())).thenAnswer(
            (_) async => CycleDetailModel(
              succeeded: true,
              data: CycleDetailDataModel(
                id: 1,
                title: 'Bi-Annual Review',
                status: 'Active',
                overallProgress: 60,
              ),
            ),
          );
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadCycleReview(cycleId: 1)),
        expect: () => [
          isA<CycleReviewLoading>(),
          isA<CycleReviewLoaded>().having(
            (s) => s.detail.title,
            'detail.title',
            'Bi-Annual Review',
          ),
        ],
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits [CycleReviewLoading, CycleReviewFailure] when data is null',
        build: () {
          when(() => mockRepo.getCycleDetail(any())).thenAnswer(
            (_) async => CycleDetailModel(succeeded: true, data: null),
          );
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadCycleReview(cycleId: 1)),
        expect: () => [
          isA<CycleReviewLoading>(),
          isA<CycleReviewFailure>().having(
            (s) => s.message,
            'message',
            'No data found',
          ),
        ],
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits [CycleReviewLoading, CycleReviewFailure] on exception',
        build: () {
          when(() => mockRepo.getCycleDetail(any()))
              .thenThrow(Exception('Network error'));
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadCycleReview(cycleId: 1)),
        expect: () => [isA<CycleReviewLoading>(), isA<CycleReviewFailure>()],
        verify: (_) {
          verify(() => mockRepo.getCycleDetail(1)).called(1);
        },
      );
    });
  });
}
