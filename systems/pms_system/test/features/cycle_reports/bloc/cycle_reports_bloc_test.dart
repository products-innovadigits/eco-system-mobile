import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/features/cycle_reports/bloc/cycle_reports_bloc.dart';
import 'package:pms_system/features/cycle_reports/bloc/cycle_reports_events.dart';
import 'package:pms_system/features/cycle_reports/bloc/cycle_reports_states.dart';
import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

void main() {
  late MockCycleReportsRepo mockRepo;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockCycleReportsRepo();
  });

  group('CycleReportsBloc', () {
    group('LoadCycleReports', () {
      blocTest<CycleReportsBloc, CycleReportsState>(
        'emits [CycleReportsLoading, CycleReportsLoaded] when repo returns data',
        build: () {
          when(() => mockRepo.getCycleReports(any())).thenAnswer(
            (_) async => [
              CycleReportItemModel(
                id: 1,
                name: 'Test User',
                jobTitle: 'Dev',
              ),
            ],
          );
          return CycleReportsBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadCycleReports(cycleId: 1)),
        expect: () => [
          isA<CycleReportsLoading>(),
          isA<CycleReportsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getCycleReports(1)).called(1);
        },
      );

      blocTest<CycleReportsBloc, CycleReportsState>(
        'CycleReportsLoaded contains correct reports',
        build: () {
          when(() => mockRepo.getCycleReports(any())).thenAnswer(
            (_) async => [
              CycleReportItemModel(id: 1, name: 'User A', jobTitle: 'Dev'),
              CycleReportItemModel(id: 2, name: 'User B', jobTitle: 'QA'),
            ],
          );
          return CycleReportsBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadCycleReports(cycleId: 1)),
        expect: () => [
          isA<CycleReportsLoading>(),
          isA<CycleReportsLoaded>().having(
            (s) => s.reports.length,
            'reports.length',
            2,
          ),
        ],
      );

      blocTest<CycleReportsBloc, CycleReportsState>(
        'emits [CycleReportsLoading, CycleReportsLoaded] with empty list',
        build: () {
          when(() => mockRepo.getCycleReports(any())).thenAnswer(
            (_) async => [],
          );
          return CycleReportsBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadCycleReports(cycleId: 1)),
        expect: () => [
          isA<CycleReportsLoading>(),
          isA<CycleReportsLoaded>().having(
            (s) => s.reports.length,
            'reports.length',
            0,
          ),
        ],
      );

      blocTest<CycleReportsBloc, CycleReportsState>(
        'emits [CycleReportsLoading, CycleReportsFailure] on exception',
        build: () {
          when(() => mockRepo.getCycleReports(any()))
              .thenThrow(Exception('Network error'));
          return CycleReportsBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadCycleReports(cycleId: 1)),
        expect: () => [
          isA<CycleReportsLoading>(),
          isA<CycleReportsFailure>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getCycleReports(1)).called(1);
        },
      );
    });
  });
}
