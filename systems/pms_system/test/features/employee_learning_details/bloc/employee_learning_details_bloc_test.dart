import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_bloc.dart';
import 'package:pms_system/features/employee_learning_details/bloc/employee_learning_details_states.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

import '../../../core/mocks/fallbacks.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  group('EmployeeLearningDetailsBloc', () {
    group('LoadEmployeeLearningDetails', () {
      blocTest<EmployeeLearningDetailsBloc, EmployeeLearningDetailsState>(
        'emits [Loading, Loaded] with mock data',
        build: () => EmployeeLearningDetailsBloc(employeeId: 1),
        act: (bloc) => bloc.add(LoadEmployeeLearningDetails()),
        wait: const Duration(milliseconds: 600),
        expect: () => [
          isA<EmployeeLearningDetailsLoading>(),
          isA<EmployeeLearningDetailsLoaded>(),
        ],
      );

      blocTest<EmployeeLearningDetailsBloc, EmployeeLearningDetailsState>(
        'Loaded state contains valid mock data',
        build: () => EmployeeLearningDetailsBloc(employeeId: 1),
        act: (bloc) => bloc.add(LoadEmployeeLearningDetails()),
        wait: const Duration(milliseconds: 600),
        expect: () => [
          isA<EmployeeLearningDetailsLoading>(),
          isA<EmployeeLearningDetailsLoaded>().having(
            (s) => s.data.employeeName,
            'data.employeeName',
            'Abdelraheem',
          ),
        ],
      );

      blocTest<EmployeeLearningDetailsBloc, EmployeeLearningDetailsState>(
        'Loaded state contains competencies and review cycles',
        build: () => EmployeeLearningDetailsBloc(employeeId: 1),
        act: (bloc) => bloc.add(LoadEmployeeLearningDetails()),
        wait: const Duration(milliseconds: 600),
        verify: (bloc) {
          final state = bloc.state;
          expect(state, isA<EmployeeLearningDetailsLoaded>());

          final loaded = state as EmployeeLearningDetailsLoaded;
          expect(loaded.data.highestCompetency, isNotNull,
              reason: 'Expected highestCompetency in loaded state');
          expect(loaded.data.lowestCompetency, isNotNull,
              reason: 'Expected lowestCompetency in loaded state');
          expect(loaded.data.reviewCycles, isNotEmpty,
              reason: 'Expected non-empty reviewCycles');
        },
      );
    });

    test('initial state is EmployeeLearningDetailsInitial', () {
      final bloc = EmployeeLearningDetailsBloc(employeeId: 1);
      expect(bloc.state, isA<EmployeeLearningDetailsInitial>());
      bloc.close();
    });

    test('employeeId is stored correctly', () {
      final bloc = EmployeeLearningDetailsBloc(employeeId: 42);
      expect(bloc.employeeId, equals(42));
      bloc.close();
    });
  });
}
