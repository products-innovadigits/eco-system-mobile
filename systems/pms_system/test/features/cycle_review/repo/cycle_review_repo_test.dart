import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/features/cycle_review/data/cycle_review_repo_impl.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late CycleReviewRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = CycleReviewRepoImpl(network: mockNetwork);
  });

  group('CycleReviewRepoImpl', () {
    group('getCycleDetail', () {
      test('returns CycleDetailModel with succeeded=true for known id', () async {
        final result = await repo.getCycleDetail(1);

        expect(result, isNotNull,
            reason: 'repo.getCycleDetail returned null');
        expect(result, isA<CycleDetailModel>(),
            reason: 'Expected CycleDetailModel');
        expect(result.succeeded, isTrue,
            reason: 'Expected succeeded to be true');
      });

      test('returns data with all required fields for cycle 1', () async {
        final result = await repo.getCycleDetail(1);

        final data = result.data;
        expect(data, isNotNull, reason: 'Expected data to be non-null');
        expect(data?.id, equals(1));
        expect(data?.title, isNotNull);
        expect(data?.reviewees, isNotNull);
        expect(data?.reviewees, isNotEmpty,
            reason: 'Expected non-empty reviewees');
        expect(data?.roleGroups, isNotNull);
        expect(data?.roleGroups, isNotEmpty,
            reason: 'Expected non-empty roleGroups');
      });

      test('returns data for cycle 2 with different title', () async {
        final result = await repo.getCycleDetail(2);

        expect(result.data?.id, equals(2));
        expect(result.data?.title, equals('Annual Performance Cycle'));
      });

      test('returns fallback data for unknown cycle id', () async {
        final result = await repo.getCycleDetail(999);

        expect(result.succeeded, isTrue,
            reason: 'Should return fallback data for unknown id');
        expect(result.data, isNotNull);
      });
    });
  });
}
