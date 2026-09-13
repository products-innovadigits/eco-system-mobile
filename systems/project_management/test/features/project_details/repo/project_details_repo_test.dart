import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late ProjectDetailsRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = ProjectDetailsRepoImpl(network: mockNetwork);
  });

  group('ProjectDetailsRepoImpl', () {
    group('getProjectDetails', () {
      test(
        'returns ProjectDetailsModel on success with correct endpoint and method',
        () async {
          final expectedModel = ProjectDetailsModel(
            succeeded: true,
            data: ProjectDetailsDataModel(id: 1, title: 'Test Project'),
          );
          const testId = 1;

          when(
            () => mockNetwork.requestOrThrow(
              any(),
              body: any(named: 'body'),
              baseUrl: any(named: 'baseUrl'),
              systemTypeEnum: any(named: 'systemTypeEnum'),
              model: any(named: 'model'),
              query: any(named: 'query'),
              header: any(named: 'header'),
              method: any(named: 'method'),
            ),
          ).thenAnswer((_) async => expectedModel);

          final result = await repo.getProjectDetails(testId);

          expect(result, isA<ProjectDetailsModel>());
          expect(result.succeeded, isTrue);
          expect(result.data?.id, 1);
          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.projectDetails(testId),
              method: ServerMethods.GET,
              model: any(named: 'model'),
            ),
          ).called(1);
        },
      );

      test('throws NetworkException on error', () async {
        const testId = 1;

        when(
          () => mockNetwork.requestOrThrow(
            any(),
            body: any(named: 'body'),
            baseUrl: any(named: 'baseUrl'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
            query: any(named: 'query'),
            header: any(named: 'header'),
            method: any(named: 'method'),
          ),
        ).thenThrow(NetworkException('Network error'));

        expect(
          () => repo.getProjectDetails(testId),
          throwsA(isA<NetworkException>()),
        );
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectDetails(testId),
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('getProjectGeneralProgressSummary', () {
      test('returns GeneralProgressChartModel and sends the chart type', () async {
        final expectedModel = GeneralProgressChartModel.fromJson({
          'totalProgress': 72.5,
          'currentMonth': 3,
          'currentYear': 2025,
        });

        when(
          () => mockNetwork.requestOrThrow(
            any(),
            body: any(named: 'body'),
            baseUrl: any(named: 'baseUrl'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
            query: any(named: 'query'),
            header: any(named: 'header'),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => expectedModel);

        final result = await repo.getProjectGeneralProgressSummary(
          1,
          chartType: ChartTime.yearly,
        );

        expect(result, isA<GeneralProgressChartModel>());
        expect(result.totalProgress, 72.5);
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectGeneralProgressSummary(1),
            query: {'type': 'yearly'},
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('projectTimeline', () {
      /// The endpoint answers with a bare array. Both shapes are covered
      /// because the parsing moved out of the bloc and into the repository.
      void stubTimelineBody(dynamic body) {
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            body: any(named: 'body'),
            baseUrl: any(named: 'baseUrl'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
            query: any(named: 'query'),
            header: any(named: 'header'),
            method: any(named: 'method'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: body,
          ),
        );
      }

      test('parses a bare array of milestones', () async {
        stubTimelineBody([
          {'id': 1, 'name': 'Discovery', 'projectId': 9},
          {'id': 2, 'name': 'Delivery', 'projectId': 9},
        ]);

        final result = await repo.projectTimeline(9);

        expect(result, hasLength(2));
        expect(result.first.name, 'Discovery');
      });

      test('parses an enveloped array under "data"', () async {
        stubTimelineBody({
          'data': [
            {'id': 1, 'name': 'Discovery', 'projectId': 9},
          ],
        });

        final result = await repo.projectTimeline(9);

        expect(result, hasLength(1));
        expect(result.first.name, 'Discovery');
      });

      test('returns an empty list for an unexpected body', () async {
        stubTimelineBody({'unexpected': true});

        expect(await repo.projectTimeline(9), isEmpty);
      });
    });
  });
}
