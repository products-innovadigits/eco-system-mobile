import 'package:core_system/core/model/search_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/features/cycle_review/data/cycle_review_repo_impl.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';
import '../../../helpers/fixture_reader.dart';

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
      test('calls network.requestOrThrow and returns CycleDetailModel',
          () async {
        final fixtureJson = readJsonFixture(
          'cycle_review/cycle_review_response.json',
        );
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).thenAnswer(
          (_) async => CycleDetailModel.fromJson(fixtureJson),
        );

        final result = await repo.getCycleDetail(1);

        expect(result, isA<CycleDetailModel>());
        expect(result.succeeded, isTrue);
        expect(result.data, isNotNull);
        expect(result.data?.id, equals(1));
        verify(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('getReviewCycleSummary', () {
      test('returns CycleSummaryResponseModel with parsed data', () async {
        final fixtureJson = readJsonFixture(
          'cycle_review/cycle_summary_response.json',
        );
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).thenAnswer(
          (_) async => CycleSummaryResponseModel.fromJson(fixtureJson),
        );

        final result = await repo.getReviewCycleSummary(cycleId: 171);

        expect(result, isA<CycleSummaryResponseModel>());
        expect(result.status, equals(200));
        expect(result.data, isNotNull);
        expect(result.data?.id, equals(171));
        expect(result.data?.overallProgress, equals(50));
      });
    });

    group('getRevieweeStatus', () {
      test('returns RevieweeStatusResponseModel with items', () async {
        final fixtureJson = readJsonFixture(
          'cycle_review/reviewee_status_response.json',
        );
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).thenAnswer(
          (_) async => RevieweeStatusResponseModel.fromJson(fixtureJson),
        );

        final result = await repo.getRevieweeStatus(cycleId: 171);

        expect(result, isA<RevieweeStatusResponseModel>());
        expect(result.data, isNotNull);
        expect(result.data!.length, equals(2));
        expect(result.total, equals(2));
        expect(result.currentPage, equals(1));
      });
    });

    group('getRevieweeStatusPaginated', () {
      test('passes query params from engine', () async {
        final fixtureJson = readJsonFixture(
          'cycle_review/reviewee_status_response.json',
        );
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            query: any(named: 'query'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).thenAnswer(
          (_) async => RevieweeStatusResponseModel.fromJson(fixtureJson),
        );

        final engine = SearchEngine();
        engine.query = {'page': 1, 'per_page': 10};

        final result = await repo.getRevieweeStatusPaginated(
          cycleId: 171,
          engine: engine,
        );

        expect(result, isA<RevieweeStatusResponseModel>());
        expect(result.data, isNotNull);
        verify(
          () => mockNetwork.requestOrThrow(
            any(),
            method: any(named: 'method'),
            query: any(named: 'query'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });
  });
}
