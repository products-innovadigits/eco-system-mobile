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
          when(() => mockRepo.getPerformanceData()).thenAnswer(
            (_) async => EmployeesPerformanceModel(
              succeeded: true,
              data: EmployeesPerformanceDataModel(
                topMonthly: [
                  PerformanceEmployeeModel(id: 1, name: 'Test', score: 99),
                ],
                topYearly: [],
                top10: [],
              ),
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
          verify(() => mockRepo.getPerformanceData()).called(1);
        },
      );

      blocTest<EmployeesPerformanceBloc, EmployeesPerformanceState>(
        'PerformanceLoaded contains correct data',
        build: () {
          when(() => mockRepo.getPerformanceData()).thenAnswer(
            (_) async => EmployeesPerformanceModel(
              succeeded: true,
              data: EmployeesPerformanceDataModel(
                topMonthly: [
                  PerformanceEmployeeModel(id: 1, name: 'Mohamed', score: 99),
                ],
                topYearly: [
                  PerformanceEmployeeModel(id: 4, name: 'Sara', score: 97),
                ],
                top10: [],
              ),
            ),
          );
          return EmployeesPerformanceBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadPerformanceData()),
        expect: () => [
          isA<PerformanceLoading>(),
          isA<PerformanceLoaded>().having(
            (s) => s.data.topMonthly?.first.name,
            'topMonthly[0].name',
            'Mohamed',
          ),
        ],
      );

      blocTest<EmployeesPerformanceBloc, EmployeesPerformanceState>(
        'emits [PerformanceLoading, PerformanceFailure] when data is null',
        build: () {
          when(() => mockRepo.getPerformanceData()).thenAnswer(
            (_) async =>
                EmployeesPerformanceModel(succeeded: true, data: null),
          );
          return EmployeesPerformanceBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadPerformanceData()),
        expect: () => [
          isA<PerformanceLoading>(),
          isA<PerformanceFailure>().having(
            (s) => s.message,
            'message',
            'No data found',
          ),
        ],
      );

      blocTest<EmployeesPerformanceBloc, EmployeesPerformanceState>(
        'emits [PerformanceLoading, PerformanceFailure] on exception',
        build: () {
          when(() => mockRepo.getPerformanceData())
              .thenThrow(Exception('Network error'));
          return EmployeesPerformanceBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const LoadPerformanceData()),
        expect: () => [
          isA<PerformanceLoading>(),
          isA<PerformanceFailure>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getPerformanceData()).called(1);
        },
      );
    });
  });
}
