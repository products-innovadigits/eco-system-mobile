import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_bloc.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_events.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_states.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

void main() {
  late MockEmployeesPerformanceRepo mockRepo;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockEmployeesPerformanceRepo();
  });

  group('EmployeesPerformanceBloc', () {
    group('LoadPerformanceData', () {
      blocTest<EmployeesPerformanceBloc, EmployeesPerformanceState>(
        'emits [PerformanceLoading, PerformanceLoaded] when repo returns data',
        build: () {
          when(() => mockRepo.getPerformanceData(type: any(named: 'type')))
              .thenAnswer(
            (_) async => EmployeesPerformanceModel(
              data: [
                PerformanceEmployeeModel(id: 1, name: 'Test', score: 99),
              ],
            ),
          );
          return EmployeesPerformanceBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadPerformanceData()),
        expect: () => [
          isA<PerformanceLoading>(),
          isA<PerformanceLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getPerformanceData(type: null)).called(1);
        },
      );

      blocTest<EmployeesPerformanceBloc, EmployeesPerformanceState>(
        'PerformanceLoaded assigns ranks and splits top3 / top10',
        build: () {
          when(() => mockRepo.getPerformanceData(type: any(named: 'type')))
              .thenAnswer(
            (_) async => EmployeesPerformanceModel(
              data: [
                PerformanceEmployeeModel(id: 1, name: 'Mohamed', score: 99),
                PerformanceEmployeeModel(id: 2, name: 'Sara', score: 97),
              ],
            ),
          );
          return EmployeesPerformanceBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadPerformanceData()),
        expect: () => [
          isA<PerformanceLoading>(),
          isA<PerformanceLoaded>()
              .having((s) => s.top10.length, 'top10.length', 2)
              .having((s) => s.top3.length, 'top3.length', 2)
              .having((s) => s.top10.first.rank, 'top10[0].rank', 1)
              .having((s) => s.top10.last.rank, 'top10[1].rank', 2)
              .having((s) => s.top3.first.name, 'top3[0].name', 'Mohamed'),
        ],
      );

      blocTest<EmployeesPerformanceBloc, EmployeesPerformanceState>(
        'passes type=yearly to repo when event has type',
        build: () {
          when(() => mockRepo.getPerformanceData(type: any(named: 'type')))
              .thenAnswer(
            (_) async => EmployeesPerformanceModel(
              data: [
                PerformanceEmployeeModel(id: 1, name: 'Test', score: 90),
              ],
            ),
          );
          return EmployeesPerformanceBloc(repo: mockRepo);
        },
        act: (bloc) =>
            bloc.add(const LoadPerformanceData(type: 'yearly')),
        expect: () => [
          isA<PerformanceLoading>(),
          isA<PerformanceLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getPerformanceData(type: 'yearly')).called(1);
        },
      );

      blocTest<EmployeesPerformanceBloc, EmployeesPerformanceState>(
        'emits PerformanceLoaded with empty lists when data is null',
        build: () {
          when(() => mockRepo.getPerformanceData(type: any(named: 'type')))
              .thenAnswer(
            (_) async => EmployeesPerformanceModel(data: null),
          );
          return EmployeesPerformanceBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadPerformanceData()),
        expect: () => [
          isA<PerformanceLoading>(),
          isA<PerformanceLoaded>()
              .having((s) => s.top3, 'top3', isEmpty)
              .having((s) => s.top10, 'top10', isEmpty),
        ],
      );

      blocTest<EmployeesPerformanceBloc, EmployeesPerformanceState>(
        'emits [PerformanceLoading, PerformanceFailure] on exception',
        build: () {
          when(() => mockRepo.getPerformanceData(type: any(named: 'type')))
              .thenThrow(Exception('Network error'));
          return EmployeesPerformanceBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadPerformanceData()),
        expect: () => [
          isA<PerformanceLoading>(),
          isA<PerformanceFailure>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getPerformanceData(type: any(named: 'type')))
              .called(1);
        },
      );
    });
  });
}
