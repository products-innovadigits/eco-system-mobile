import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/model/search_engine.dart';
import 'package:core_system/core/network/error/network_exception.dart';
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

    group('LoadReviewCycleSummary', () {
      CycleSummaryResponseModel _makeSummaryModel() {
        return CycleSummaryResponseModel(
          status: 200,
          message: 'Fetched Successfully',
          data: CycleSummaryDataModel(
            id: 171,
            name: 'Test Cycle',
            state: 'active',
            overallProgress: 50,
            completedCount: 1,
            totalCount: 2,
            reviewersCount: 2,
            managers: RoleGroupInfoModel(count: 2, deadline: 5),
          ),
        );
      }

      RevieweeStatusResponseModel _makeRevieweeModel({int total = 2}) {
        return RevieweeStatusResponseModel(
          data: [
            RevieweeStatusItemModel(
              id: 12,
              name: 'Nhyd Basha',
              jobTitle: 'Developer',
              overallProgress: 50,
              completedCount: 1,
              totalCount: 2,
            ),
          ],
          currentPage: 1,
          lastPage: 1,
          total: total,
          perPage: 10,
        );
      }

      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits [ReviewCycleSummaryLoading, ReviewCycleSummaryLoaded] on success',
        build: () {
          when(() => mockRepo.getReviewCycleSummary(cycleId: any(named: 'cycleId')))
              .thenAnswer((_) async => _makeSummaryModel());
          when(() => mockRepo.getRevieweeStatus(cycleId: any(named: 'cycleId')))
              .thenAnswer((_) async => _makeRevieweeModel());
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) =>
            bloc.add(const LoadReviewCycleSummary(cycleId: 171)),
        expect: () => [
          isA<ReviewCycleSummaryLoading>(),
          isA<ReviewCycleSummaryLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getReviewCycleSummary(cycleId: 171)).called(1);
          verify(() => mockRepo.getRevieweeStatus(cycleId: 171)).called(1);
        },
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'ReviewCycleSummaryLoaded contains correct summary and totalReviewees',
        build: () {
          when(() => mockRepo.getReviewCycleSummary(cycleId: any(named: 'cycleId')))
              .thenAnswer((_) async => _makeSummaryModel());
          when(() => mockRepo.getRevieweeStatus(cycleId: any(named: 'cycleId')))
              .thenAnswer((_) async => _makeRevieweeModel(total: 5));
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) =>
            bloc.add(const LoadReviewCycleSummary(cycleId: 171)),
        expect: () => [
          isA<ReviewCycleSummaryLoading>(),
          isA<ReviewCycleSummaryLoaded>()
              .having((s) => s.summary.id, 'summary.id', 171)
              .having((s) => s.summary.name, 'summary.name', 'Test Cycle')
              .having((s) => s.totalReviewees, 'totalReviewees', 5)
              .having(
                (s) => s.revieweeStatusItems.length,
                'revieweeStatusItems.length',
                1,
              ),
        ],
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits [ReviewCycleSummaryLoading, ReviewCycleSummaryFailure] when summary data is null',
        build: () {
          when(() => mockRepo.getReviewCycleSummary(cycleId: any(named: 'cycleId')))
              .thenAnswer(
            (_) async => CycleSummaryResponseModel(
              status: 200,
              message: 'OK',
              data: null,
            ),
          );
          when(() => mockRepo.getRevieweeStatus(cycleId: any(named: 'cycleId')))
              .thenAnswer((_) async => _makeRevieweeModel());
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) =>
            bloc.add(const LoadReviewCycleSummary(cycleId: 171)),
        expect: () => [
          isA<ReviewCycleSummaryLoading>(),
          isA<ReviewCycleSummaryFailure>().having(
            (s) => s.message,
            'message',
            'No data found',
          ),
        ],
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits [ReviewCycleSummaryLoading, ReviewCycleSummaryFailure] on NetworkException',
        build: () {
          when(() => mockRepo.getReviewCycleSummary(cycleId: any(named: 'cycleId')))
              .thenThrow(const NetworkException('Server Error'));
          when(() => mockRepo.getRevieweeStatus(cycleId: any(named: 'cycleId')))
              .thenAnswer((_) async => _makeRevieweeModel());
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) =>
            bloc.add(const LoadReviewCycleSummary(cycleId: 171)),
        expect: () => [
          isA<ReviewCycleSummaryLoading>(),
          isA<ReviewCycleSummaryFailure>().having(
            (s) => s.message,
            'message',
            'Server Error',
          ),
        ],
      );
    });

    group('LoadReviewees', () {
      RevieweeStatusResponseModel _makePagedResponse({
        int currentPage = 1,
        int lastPage = 2,
        int total = 20,
      }) {
        return RevieweeStatusResponseModel(
          data: [
            RevieweeStatusItemModel(
              id: currentPage * 10,
              name: 'User $currentPage',
              jobTitle: 'Dev',
              overallProgress: 80,
              completedCount: 2,
              totalCount: 3,
            ),
          ],
          currentPage: currentPage,
          lastPage: lastPage,
          total: total,
          perPage: 10,
        );
      }

      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits [RevieweesLoading, RevieweesLoaded] on first page success',
        build: () {
          when(
            () => mockRepo.getRevieweeStatusPaginated(
              cycleId: any(named: 'cycleId'),
              engine: any(named: 'engine'),
            ),
          ).thenAnswer((_) async => _makePagedResponse());
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(
          LoadReviewees(cycleId: 171, searchEngine: SearchEngine()),
        ),
        expect: () => [
          isA<RevieweesLoading>(),
          isA<RevieweesLoaded>()
              .having((s) => s.reviewees.length, 'reviewees.length', 1)
              .having((s) => s.isLoadingMore, 'isLoadingMore', false),
        ],
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits RevieweesEmpty when response data is empty and no existing items',
        build: () {
          when(
            () => mockRepo.getRevieweeStatusPaginated(
              cycleId: any(named: 'cycleId'),
              engine: any(named: 'engine'),
            ),
          ).thenAnswer(
            (_) async => RevieweeStatusResponseModel(
              data: [],
              currentPage: 1,
              lastPage: 1,
              total: 0,
              perPage: 10,
            ),
          );
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(
          LoadReviewees(cycleId: 171, searchEngine: SearchEngine()),
        ),
        expect: () => [
          isA<RevieweesLoading>(),
          isA<RevieweesEmpty>(),
        ],
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'emits RevieweesFailure on NetworkException with no existing data',
        build: () {
          when(
            () => mockRepo.getRevieweeStatusPaginated(
              cycleId: any(named: 'cycleId'),
              engine: any(named: 'engine'),
            ),
          ).thenThrow(const NetworkException('Connection failed'));
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(
          LoadReviewees(cycleId: 171, searchEngine: SearchEngine()),
        ),
        expect: () => [
          isA<RevieweesLoading>(),
          isA<RevieweesFailure>().having(
            (s) => s.message,
            'message',
            'Connection failed',
          ),
        ],
      );

      blocTest<CycleReviewBloc, CycleReviewState>(
        'RevieweesLoaded.hasMore reflects pagination state',
        build: () {
          when(
            () => mockRepo.getRevieweeStatusPaginated(
              cycleId: any(named: 'cycleId'),
              engine: any(named: 'engine'),
            ),
          ).thenAnswer(
            (_) async => _makePagedResponse(
              currentPage: 1,
              lastPage: 3,
              total: 30,
            ),
          );
          return CycleReviewBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(
          LoadReviewees(cycleId: 171, searchEngine: SearchEngine()),
        ),
        expect: () => [
          isA<RevieweesLoading>(),
          isA<RevieweesLoaded>().having((s) => s.hasMore, 'hasMore', true),
        ],
      );
    });
  });
}
