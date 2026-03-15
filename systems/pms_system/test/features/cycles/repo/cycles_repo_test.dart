import 'package:flutter_test/flutter_test.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/data/cycles_repo_impl.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late CyclesRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = CyclesRepoImpl(network: mockNetwork);
  });

  group('CyclesRepoImpl', () {
    group('getCycles', () {
      test('returns CyclesModel with succeeded=true', () async {
        final searchEngine = SearchEngine();

        final result = await repo.getCycles(searchEngine);

        expect(result, isNotNull,
            reason: 'repo.getCycles returned null unexpectedly');
        expect(result, isA<CyclesModel>(),
            reason: 'Expected CyclesModel, got ${result.runtimeType}');
        expect(result.succeeded, isTrue,
            reason: 'Expected CyclesModel.succeeded to be true');
      });

      test('returns data with items', () async {
        final searchEngine = SearchEngine();

        final result = await repo.getCycles(searchEngine);

        expect(result.data, isNotNull,
            reason: 'Expected data to be non-null');
        expect(result.data?.items, isNotNull,
            reason: 'Expected items list');
        expect(result.data!.items!, isNotEmpty,
            reason: 'Expected non-empty items from simulated data');
      });

      test('returns correct pagination info', () async {
        final searchEngine = SearchEngine();

        final result = await repo.getCycles(searchEngine);

        expect(result.data?.currentPage, isNotNull,
            reason: 'Expected currentPage');
        expect(result.data?.totalPages, isNotNull,
            reason: 'Expected totalPages');
        expect(result.data?.totalCount, isNotNull,
            reason: 'Expected totalCount');
      });

      test('filters results by search keyword', () async {
        final searchEngine = SearchEngine(
          query: <String, dynamic>{'searchKeyword': 'Annual'},
        );

        final result = await repo.getCycles(searchEngine);

        expect(result.data?.items, isNotNull);
        for (final item in result.data!.items!) {
          expect(
            item.title!.toLowerCase().contains('annual'),
            isTrue,
            reason: 'Item "${item.title}" should contain "annual"',
          );
        }
      });

      test('returns empty items when search keyword has no match', () async {
        final searchEngine = SearchEngine(
          query: <String, dynamic>{
            'searchKeyword': 'zzz_nonexistent_zzz',
          },
        );

        final result = await repo.getCycles(searchEngine);

        expect(result.data?.items, isNotNull);
        expect(result.data!.items!, isEmpty,
            reason: 'Expected empty items for non-matching search');
      });
    });
  });
}
