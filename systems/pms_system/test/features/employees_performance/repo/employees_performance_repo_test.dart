import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/employees_performance/data/employees_performance_repo_impl.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late EmployeesPerformanceRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = EmployeesPerformanceRepoImpl(network: mockNetwork);
  });

  group('EmployeesPerformanceRepoImpl', () {
    group('getPerformanceData', () {
      test('returns EmployeesPerformanceModel with succeeded=true', () async {
        final result = await repo.getPerformanceData();

        expect(result, isNotNull,
            reason: 'repo.getPerformanceData returned null');
        expect(result, isA<EmployeesPerformanceModel>(),
            reason: 'Expected EmployeesPerformanceModel');
        expect(result.succeeded, isTrue,
            reason: 'Expected succeeded to be true');
      });

      test('returns data with all three ranking lists', () async {
        final result = await repo.getPerformanceData();

        final data = result.data;
        expect(data, isNotNull, reason: 'Expected data to be non-null');

        expect(data?.topMonthly, isNotNull,
            reason: 'Expected topMonthly list');
        expect(data!.topMonthly!, isNotEmpty,
            reason: 'Expected non-empty topMonthly');

        expect(data.topYearly, isNotNull,
            reason: 'Expected topYearly list');
        expect(data.topYearly!, isNotEmpty,
            reason: 'Expected non-empty topYearly');

        expect(data.top10, isNotNull, reason: 'Expected top10 list');
        expect(data.top10!, isNotEmpty,
            reason: 'Expected non-empty top10');
      });

      test('top employees have required fields', () async {
        final result = await repo.getPerformanceData();
        final topMonthly = result.data!.topMonthly!;

        for (final employee in topMonthly) {
          expect(employee.id, isNotNull,
              reason: 'Each employee should have an id');
          expect(employee.name, isNotNull,
              reason: 'Each employee should have a name');
          expect(employee.score, isNotNull,
              reason: 'Each employee should have a score');
          expect(employee.rank, isNotNull,
              reason: 'Each employee should have a rank');
        }
      });
    });
  });
}
