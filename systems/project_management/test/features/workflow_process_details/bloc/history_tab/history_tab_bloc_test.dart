import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/history_tab/history_tab_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/history_tab/history_tab_events.dart';
import 'package:project_management/features/workflow_process_details/bloc/history_tab/history_tab_state.dart';
import 'package:project_management/features/workflow_process_details/model/history_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProcessDetailsRepo mockRepo;
  late HistoryTabBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProcessDetailsRepo();
    bloc = HistoryTabBloc(repo: mockRepo);
  });

  tearDown(() {
  });

  group('HistoryTabBloc', () {
    group('LoadHistoryData', () {
      blocTest<HistoryTabBloc, HistoryTabState>(
        'emits [HistoryTabLoading, HistoryTabLoaded] when repo returns data',
        build: () {
          when(
            () => mockRepo.getHistoryData(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenAnswer(
            (_) async => HistoryResponseModel(
              succeeded: true,
              data: [HistoryItemModel(id: 1, name: 'Test History')],
            ),
          );
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoadHistoryData(processId: 1, projectId: 1)),
        expect: () => [const HistoryTabLoading(), isA<HistoryTabLoaded>()],
        verify: (_) {
          verify(
            () => mockRepo.getHistoryData(processId: 1, projectId: 1),
          ).called(1);
        },
      );

      blocTest<HistoryTabBloc, HistoryTabState>(
        'emits [HistoryTabLoading, HistoryTabEmpty] when repo returns empty data',
        build: () {
          when(
            () => mockRepo.getHistoryData(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenAnswer(
            (_) async => HistoryResponseModel(succeeded: true, data: []),
          );
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoadHistoryData(processId: 1, projectId: 1)),
        expect: () => [const HistoryTabLoading(), isA<HistoryTabEmpty>()],
      );

      blocTest<HistoryTabBloc, HistoryTabState>(
        'emits [HistoryTabLoading, HistoryTabFailure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getHistoryData(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoadHistoryData(processId: 1, projectId: 1)),
        expect: () => [const HistoryTabLoading(), isA<HistoryTabFailure>()],
      );
    });
  });
}
