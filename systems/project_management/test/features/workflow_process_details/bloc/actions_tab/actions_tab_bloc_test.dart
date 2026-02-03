import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/actions_tab/actions_tab_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/actions_tab/actions_tab_events.dart';
import 'package:project_management/features/workflow_process_details/bloc/actions_tab/actions_tab_state.dart';
import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProcessDetailsRepo mockRepo;
  late ActionsTabBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProcessDetailsRepo();
    bloc = ActionsTabBloc(repo: mockRepo);
  });

  tearDown(() {
  });

  group('ActionsTabBloc', () {
    group('MoveToNextStep', () {
      blocTest<ActionsTabBloc, ActionsTabState>(
        'emits [MoveToNextStepLoading, MoveToNextStepSuccess] when repo returns success',
        build: () {
          when(
            () => mockRepo.moveToNextStep(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
              nextStepId: any(named: 'nextStepId'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
            ),
          );
          when(
            () => mockRepo.getCurrentStepDocs(
              projectId: any(named: 'projectId'),
              processId: any(named: 'processId'),
              projectStepId: any(named: 'projectStepId'),
            ),
          ).thenAnswer((_) async => CurrentStepDocumentModel(succeeded: true));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const MoveToNextStep(projectId: 1, processId: 1, nextStepId: 2),
        ),
        expect: () => [
          const MoveToNextStepLoading(),
          isA<MoveToNextStepSuccess>(),
        ],
        verify: (_) {
          verify(
            () => mockRepo.moveToNextStep(
              processId: 1,
              projectId: 1,
              nextStepId: 2,
            ),
          ).called(1);
        },
      );

      blocTest<ActionsTabBloc, ActionsTabState>(
        'emits [MoveToNextStepLoading, ActionsTabFailure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.moveToNextStep(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
              nextStepId: any(named: 'nextStepId'),
            ),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const MoveToNextStep(projectId: 1, processId: 1, nextStepId: 2),
        ),
        expect: () => [const MoveToNextStepLoading(), isA<ActionsTabFailure>()],
      );
    });
  });
}
