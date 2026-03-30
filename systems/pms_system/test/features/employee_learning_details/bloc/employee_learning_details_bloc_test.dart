import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_bloc.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_events.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_states.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

ReviewCyclesModel _fakeReviewCycles() => ReviewCyclesModel(
  data: [
    ReviewCycleItemModel(
      id: 8,
      name: 'Senior Mobile Developer 2025-06-18',
      startDate: '2025-06-18',
      closedDate: '2026-03-29',
      isLearningAssignmentSent: 1,
      report: ReviewCycleReportModel(
        finalScore: 3.89,
        strongestFactor: ReportAreaModel(avg: 4.3, name: 'Professionalism'),
        weakestFactor: ReportAreaModel(avg: 3.0, name: 'Technical Mastery'),
      ),
    ),
  ],
);

LastReviewCycleReportModel _fakeLastReport() => LastReviewCycleReportModel(
  id: 38,
  createdAt: '2025-07-06 10:12:42',
  name: 'Mid - Level | Mobile Developer',
  reportData: ReviewCycleReportModel(
    finalScore: 4.01,
    strongestFactor: ReportAreaModel(
      avg: 4.33,
      name: 'App Maintenance & Optimization',
    ),
    weakestFactor: ReportAreaModel(
      avg: 3.25,
      name: 'Mobile Development Execution',
    ),
  ),
);

const _event = LoadEmployeeLearningDetails(
  employeeId: 1,
  employeeName: 'Test User',
);

void _stubSuccess(MockEmployeeLearningDetailsRepo repo) {
  when(
    () => repo.getReviewCycles(userId: any(named: 'userId')),
  ).thenAnswer((_) async => _fakeReviewCycles());
  when(
    () => repo.getLastReviewCycleReport(userId: any(named: 'userId')),
  ).thenAnswer((_) async => _fakeLastReport());
}

void main() {
  late MockEmployeeLearningDetailsRepo mockRepo;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockEmployeeLearningDetailsRepo();
  });

  EmployeeLearningDetailsBloc buildBloc() =>
      EmployeeLearningDetailsBloc(repo: mockRepo);

  group('EmployeeLearningDetailsBloc', () {
    group('LoadEmployeeLearningDetails', () {
      blocTest<EmployeeLearningDetailsBloc, EmployeeLearningDetailsState>(
        'emits [Loading, Loaded] on success',
        setUp: () => _stubSuccess(mockRepo),
        build: buildBloc,
        act: (bloc) => bloc.add(_event),
        expect: () => [
          isA<EmployeeLearningDetailsLoading>(),
          isA<EmployeeLearningDetailsLoaded>(),
        ],
      );

      blocTest<EmployeeLearningDetailsBloc, EmployeeLearningDetailsState>(
        'Loaded state maps competencies from last report',
        setUp: () => _stubSuccess(mockRepo),
        build: buildBloc,
        act: (bloc) => bloc.add(_event),
        verify: (bloc) {
          final state = bloc.state;
          expect(state, isA<EmployeeLearningDetailsLoaded>());

          final loaded = state as EmployeeLearningDetailsLoaded;
          expect(loaded.data.highestCompetency, isNotNull);
          expect(
            loaded.data.highestCompetency!.name,
            'App Maintenance & Optimization',
          );
          expect(loaded.data.lowestCompetency, isNotNull);
          expect(
            loaded.data.lowestCompetency!.name,
            'Mobile Development Execution',
          );
          expect(loaded.data.reviewCycles, isNotEmpty);
          expect(loaded.data.employeeName, 'Test User');
        },
      );

      blocTest<EmployeeLearningDetailsBloc, EmployeeLearningDetailsState>(
        'emits Loaded without competencies when last report fails',
        setUp: () {
          when(
            () => mockRepo.getReviewCycles(userId: any(named: 'userId')),
          ).thenAnswer((_) async => _fakeReviewCycles());
          when(
            () =>
                mockRepo.getLastReviewCycleReport(userId: any(named: 'userId')),
          ).thenThrow(Exception('server error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(_event),
        verify: (bloc) {
          final state = bloc.state;
          expect(state, isA<EmployeeLearningDetailsLoaded>());

          final loaded = state as EmployeeLearningDetailsLoaded;
          expect(loaded.data.highestCompetency, isNull);
          expect(loaded.data.lowestCompetency, isNull);
          expect(loaded.data.reviewCycles, isNotEmpty);
        },
      );

      blocTest<EmployeeLearningDetailsBloc, EmployeeLearningDetailsState>(
        'emits [Loading, Failure] when both calls fail',
        setUp: () {
          when(
            () => mockRepo.getReviewCycles(userId: any(named: 'userId')),
          ).thenThrow(Exception('network error'));
          when(
            () =>
                mockRepo.getLastReviewCycleReport(userId: any(named: 'userId')),
          ).thenThrow(Exception('network error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(_event),
        expect: () => [
          isA<EmployeeLearningDetailsLoading>(),
          isA<EmployeeLearningDetailsFailure>(),
        ],
      );
    });

    test('initial state is EmployeeLearningDetailsInitial', () {
      _stubSuccess(mockRepo);
      final bloc = buildBloc();
      expect(bloc.state, isA<EmployeeLearningDetailsInitial>());
      bloc.close();
    });
  });
}
