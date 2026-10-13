import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/process_details/process_details_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/process_details/process_details_events.dart';
import 'package:project_management/features/workflow_process_details/bloc/process_details/process_details_state.dart';
import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';
import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';
import 'package:project_management/features/workflow_process_details/model/stage_doc_model.dart';
import 'package:project_management/shared/model/default_response_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProcessDetailsRepo mockRepo;
  late ProcessDetailsBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProcessDetailsRepo();
    bloc = ProcessDetailsBloc(repo: mockRepo);
  });

  tearDown(() {});

  group('ProcessDetailsBloc', () {
    group('LoadGroupSteps', () {
      blocTest<ProcessDetailsBloc, ProcessDetailsState>(
        'emits [GroupStepsLoading, GroupStepsLoaded] when repo returns data',
        build: () {
          when(
            () => mockRepo.getGroupSteps(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenAnswer(
            (_) async => GroupStepsModel(
              succeeded: true,
              data: [GroupStepsData(groupId: 1, groupName: 'Test Group')],
            ),
          );
          when(
            () => mockRepo.getCurrentNextSteps(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenAnswer((_) async => StageDocResponseModel(succeeded: true));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoadGroupSteps(processId: 1, projectId: 1)),
        expect: () => [const GroupStepsLoading(), isA<GroupStepsLoaded>()],
        verify: (_) {
          verify(
            () => mockRepo.getGroupSteps(processId: 1, projectId: 1),
          ).called(1);
        },
      );

      blocTest<ProcessDetailsBloc, ProcessDetailsState>(
        'emits [GroupStepsLoading, GroupStepsEmpty] when repo returns empty data',
        build: () {
          when(
            () => mockRepo.getGroupSteps(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenAnswer((_) async => GroupStepsModel(succeeded: true, data: []));
          when(
            () => mockRepo.getCurrentNextSteps(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenAnswer((_) async => StageDocResponseModel(succeeded: true));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoadGroupSteps(processId: 1, projectId: 1)),
        expect: () => [const GroupStepsLoading(), isA<GroupStepsEmpty>()],
      );

      blocTest<ProcessDetailsBloc, ProcessDetailsState>(
        'emits [GroupStepsLoading, GroupStepsFailure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getGroupSteps(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoadGroupSteps(processId: 1, projectId: 1)),
        expect: () => [const GroupStepsLoading(), isA<GroupStepsFailure>()],
      );
    });

    group('StartProcess', () {
      // Current & Next before the start reports the pre-start step (1); after
      // the start it reports the step the process landed on (42).
      late int currentNextCalls;

      void stubScreen({bool docsThrow = false}) {
        currentNextCalls = 0;
        when(
          () => mockRepo.getGroupSteps(
            processId: any(named: 'processId'),
            projectId: any(named: 'projectId'),
          ),
        ).thenAnswer(
          (_) async => GroupStepsModel(
            succeeded: true,
            data: [GroupStepsData(groupId: 1, groupName: 'Group')],
          ),
        );
        when(
          () => mockRepo.getCurrentNextSteps(
            processId: any(named: 'processId'),
            projectId: any(named: 'projectId'),
          ),
        ).thenAnswer((_) async {
          final stepId = currentNextCalls++ == 0 ? 1 : 42;
          return StageDocResponseModel(
            succeeded: true,
            data: StageDocData(currentStep: WorkflowStep(id: stepId)),
          );
        });
        final docsCall = when(
          () => mockRepo.getCurrentStepDocs(
            projectId: any(named: 'projectId'),
            processId: any(named: 'processId'),
            projectStepId: any(named: 'projectStepId'),
          ),
        );
        if (docsThrow) {
          // A step without documents answers with a 4xx.
          docsCall.thenThrow(NetworkException('لا يوجد مستندات لهذه الخطوة'));
        } else {
          docsCall.thenAnswer(
            (_) async => CurrentStepDocumentModel(succeeded: true),
          );
        }
      }

      blocTest<ProcessDetailsBloc, ProcessDetailsState>(
        'creates the new step docs before Current & Next is reloaded',
        build: () {
          stubScreen();
          when(
            () => mockRepo.startProcess(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenAnswer((_) async => DefaultResponseModel(succeeded: true));
          return bloc;
        },
        act: (bloc) async {
          bloc.add(const LoadGroupSteps(processId: 1, projectId: 1));
          await Future<void>.delayed(Duration.zero);
          bloc.add(const StartProcess(processId: 1, projectId: 1));
        },
        expect: () => [
          const GroupStepsLoading(),
          isA<GroupStepsLoaded>(),
          const ProcessStarting(),
          isA<GroupStepsLoaded>(),
        ],
        verify: (bloc) {
          verifyInOrder([
            () => mockRepo.startProcess(processId: 1, projectId: 1),
            () => mockRepo.getCurrentNextSteps(processId: 1, projectId: 1),
            // The step the process landed on, not the cached pre-start one.
            () => mockRepo.getCurrentStepDocs(
              projectId: 1,
              processId: 1,
              projectStepId: 42,
            ),
            () => mockRepo.getCurrentNextSteps(processId: 1, projectId: 1),
          ]);
          verifyNever(
            () => mockRepo.getCurrentStepDocs(
              projectId: 1,
              processId: 1,
              projectStepId: 1,
            ),
          );
          expect(bloc.stageDocsData?.currentStep?.id, 42);
        },
      );

      blocTest<ProcessDetailsBloc, ProcessDetailsState>(
        'still reloads the screen when the new step has no documents',
        build: () {
          stubScreen(docsThrow: true);
          when(
            () => mockRepo.startProcess(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenAnswer((_) async => DefaultResponseModel(succeeded: true));
          return bloc;
        },
        act: (bloc) => bloc.add(const StartProcess(processId: 1, projectId: 1)),
        expect: () => [const ProcessStarting(), isA<GroupStepsLoaded>()],
        verify: (_) {
          verify(
            () => mockRepo.getGroupSteps(processId: 1, projectId: 1),
          ).called(1);
        },
      );

      blocTest<ProcessDetailsBloc, ProcessDetailsState>(
        'returns to the screen without touching the steps when start fails',
        build: () {
          stubScreen();
          when(
            () => mockRepo.startProcess(
              processId: any(named: 'processId'),
              projectId: any(named: 'projectId'),
            ),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) async {
          bloc.add(const LoadGroupSteps(processId: 1, projectId: 1));
          await Future<void>.delayed(Duration.zero);
          bloc.add(const StartProcess(processId: 1, projectId: 1));
        },
        expect: () => [
          const GroupStepsLoading(),
          isA<GroupStepsLoaded>(),
          const ProcessStarting(),
          isA<GroupStepsLoaded>(),
        ],
        verify: (_) {
          verifyNever(
            () => mockRepo.getCurrentStepDocs(
              projectId: any(named: 'projectId'),
              processId: any(named: 'processId'),
              projectStepId: any(named: 'projectStepId'),
            ),
          );
          // Only the initial load read Current & Next.
          expect(currentNextCalls, 1);
        },
      );
    });
  });
}
