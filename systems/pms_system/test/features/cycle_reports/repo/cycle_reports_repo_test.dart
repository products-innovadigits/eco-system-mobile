import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/cycle_reports/data/cycle_reports_repo_impl.dart';
import 'package:pms_system/features/cycle_reports/model/cycle_reports_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late CycleReportsRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = CycleReportsRepoImpl(network: mockNetwork);
  });

  group('CycleReportsRepoImpl', () {
    group('getCycleReports', () {
      test('returns list of CycleReportItemModel', () async {
        final result = await repo.getCycleReports(1);

        expect(result, isNotNull,
            reason: 'repo.getCycleReports returned null');
        expect(result, isA<List<CycleReportItemModel>>(),
            reason: 'Expected List<CycleReportItemModel>');
        expect(result, isNotEmpty,
            reason: 'Expected non-empty reports list');
      });

      test('each report has required fields', () async {
        final result = await repo.getCycleReports(1);

        for (final report in result) {
          expect(report.id, isNonZero,
              reason: 'Each report should have a non-zero id');
          expect(report.name, isNotEmpty,
              reason: 'Each report should have a non-empty name');
          expect(report.jobTitle, isNotEmpty,
              reason: 'Each report should have a non-empty jobTitle');
        }
      });

      test('returns same data regardless of cycleId (simulated)', () async {
        final result1 = await repo.getCycleReports(1);
        final result2 = await repo.getCycleReports(999);

        expect(result1.length, equals(result2.length),
            reason: 'Simulated data should return same list for any cycleId');
      });
    });
  });
}
