import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/pms_exports.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProjectDetailsRepo mockRepo;
  late ProjectGeneralProgressSummaryBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectDetailsRepo();
    bloc = ProjectGeneralProgressSummaryBloc(repo: mockRepo);
  });

  tearDown(() {
  });

  group('ProjectGeneralProgressSummaryBloc', () {
    group('LoadGeneralProgressSummary', () {
      blocTest<
        ProjectGeneralProgressSummaryBloc,
        ProjectGeneralProgressSummaryState
      >(
        'emits [Loading, Loaded] when repo returns success response',
        build: () {
          when(
            () => mockRepo.getProjectGeneralProgressSummary(
              any(),
              chartType: any(named: 'chartType'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'progress': 50.0},
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoadGeneralProgressSummary(
            projectId: 1,
            chartType: ChartTime.monthly,
          ),
        ),
        expect: () => [
          const ProjectGeneralProgressSummaryLoading(),
          isA<ProjectGeneralProgressSummaryLoaded>(),
        ],
        verify: (_) {
          verify(
            () => mockRepo.getProjectGeneralProgressSummary(
              1,
              chartType: ChartTime.monthly,
            ),
          ).called(1);
        },
      );

      blocTest<
        ProjectGeneralProgressSummaryBloc,
        ProjectGeneralProgressSummaryState
      >(
        'emits [Loading, Failure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectGeneralProgressSummary(
              any(),
              chartType: any(named: 'chartType'),
            ),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoadGeneralProgressSummary(
            projectId: 1,
            chartType: ChartTime.monthly,
          ),
        ),
        expect: () => [
          const ProjectGeneralProgressSummaryLoading(),
          isA<ProjectGeneralProgressSummaryFailure>(),
        ],
      );
    });
  });
}
