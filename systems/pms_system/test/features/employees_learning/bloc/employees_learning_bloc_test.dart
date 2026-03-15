import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_events.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_states.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filter_provider.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

class MockEmployeesFilterProvider extends Mock
    implements EmployeesFilterProvider {}

void main() {
  late MockEmployeesLearningRepo mockRepo;
  late MockEmployeesFilterProvider mockFilterProvider;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockEmployeesLearningRepo();
    mockFilterProvider = MockEmployeesFilterProvider();
    when(() => mockFilterProvider.getFilterParams()).thenReturn({});
  });

  group('EmployeesLearningBloc', () {
    group('LoadEmployees', () {
      blocTest<EmployeesLearningBloc, EmployeesLearningState>(
        'emits [EmployeesLoading, EmployeesLoaded] when repo returns data',
        build: () {
          when(() => mockRepo.getEmployees(any())).thenAnswer(
            (_) async => EmployeesLearningModel(
              succeeded: true,
              data: EmployeesDataModel(
                items: [EmployeeItemModel(id: 1, name: 'Test Employee')],
                currentPage: 1,
                totalPages: 1,
                totalCount: 1,
                pageSize: 10,
              ),
            ),
          );
          return EmployeesLearningBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) =>
            bloc.add(LoadEmployees(searchEngine: SearchEngine())),
        expect: () => [isA<EmployeesLoading>(), isA<EmployeesLoaded>()],
        verify: (_) {
          verify(() => mockRepo.getEmployees(any())).called(1);
        },
      );

      blocTest<EmployeesLearningBloc, EmployeesLearningState>(
        'emits [EmployeesLoading, EmployeesEmpty] when repo returns empty data',
        build: () {
          when(() => mockRepo.getEmployees(any())).thenAnswer(
            (_) async => EmployeesLearningModel(
              succeeded: true,
              data: EmployeesDataModel(items: []),
            ),
          );
          return EmployeesLearningBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) =>
            bloc.add(LoadEmployees(searchEngine: SearchEngine())),
        expect: () => [isA<EmployeesLoading>(), isA<EmployeesEmpty>()],
      );

      blocTest<EmployeesLearningBloc, EmployeesLearningState>(
        'emits [EmployeesLoading, EmployeesFailure] on NetworkException',
        build: () {
          when(() => mockRepo.getEmployees(any()))
              .thenThrow(NetworkException('Network error'));
          return EmployeesLearningBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) =>
            bloc.add(LoadEmployees(searchEngine: SearchEngine())),
        expect: () => [isA<EmployeesLoading>(), isA<EmployeesFailure>()],
        verify: (_) {
          verify(() => mockRepo.getEmployees(any())).called(1);
        },
      );

      blocTest<EmployeesLearningBloc, EmployeesLearningState>(
        'emits [EmployeesLoading, EmployeesFailure] on generic exception',
        build: () {
          when(() => mockRepo.getEmployees(any()))
              .thenThrow(Exception('Something went wrong'));
          return EmployeesLearningBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) =>
            bloc.add(LoadEmployees(searchEngine: SearchEngine())),
        expect: () => [isA<EmployeesLoading>(), isA<EmployeesFailure>()],
      );
    });

    group('EmployeesSearchChanged', () {
      blocTest<EmployeesLearningBloc, EmployeesLearningState>(
        'triggers LoadEmployees and emits states',
        build: () {
          when(() => mockRepo.getEmployees(any())).thenAnswer(
            (_) async => EmployeesLearningModel(
              succeeded: true,
              data: EmployeesDataModel(items: []),
            ),
          );
          return EmployeesLearningBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) => bloc.add(const EmployeesSearchChanged('test')),
        expect: () => [isA<EmployeesLoading>(), isA<EmployeesEmpty>()],
        verify: (_) {
          verify(() => mockRepo.getEmployees(any())).called(1);
        },
      );
    });

    group('RefreshEmployees', () {
      blocTest<EmployeesLearningBloc, EmployeesLearningState>(
        'clears data and reloads',
        build: () {
          when(() => mockRepo.getEmployees(any())).thenAnswer(
            (_) async => EmployeesLearningModel(
              succeeded: true,
              data: EmployeesDataModel(
                items: [EmployeeItemModel(id: 1, name: 'Refreshed')],
                currentPage: 1,
                totalPages: 1,
                totalCount: 1,
                pageSize: 10,
              ),
            ),
          );
          return EmployeesLearningBloc(
            repo: mockRepo,
            filterProvider: mockFilterProvider,
          );
        },
        act: (bloc) => bloc.add(const RefreshEmployees()),
        expect: () => [isA<EmployeesLoading>(), isA<EmployeesLoaded>()],
        verify: (_) {
          verify(() => mockRepo.getEmployees(any())).called(1);
        },
      );
    });
  });
}
