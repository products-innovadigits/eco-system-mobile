import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/actions_tab/actions_tab_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/actions_tab/actions_tab_events.dart';
import 'package:project_management/features/workflow_process_details/bloc/actions_tab/actions_tab_state.dart';
import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';
import 'package:project_management/shared/model/default_response_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProcessDetailsRepo mockRepo;
  late ActionsTabBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
    // Saving shows a toast; the plugin has no platform here.
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('PonnamKarthik/fluttertoast'),
          (_) async => true,
        );
  });

  setUp(() {
    mockRepo = MockProcessDetailsRepo();
    bloc = ActionsTabBloc(repo: mockRepo);
  });

  tearDown(() {});

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
          ).thenAnswer((_) async => DefaultResponseModel(succeeded: true));
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

      void stubMove() {
        when(
          () => mockRepo.moveToNextStep(
            processId: any(named: 'processId'),
            projectId: any(named: 'projectId'),
            nextStepId: any(named: 'nextStepId'),
          ),
        ).thenAnswer((_) async => DefaultResponseModel(succeeded: true));
        when(
          () => mockRepo.getCurrentStepDocs(
            projectId: any(named: 'projectId'),
            processId: any(named: 'processId'),
            projectStepId: any(named: 'projectStepId'),
          ),
        ).thenAnswer((_) async => CurrentStepDocumentModel(succeeded: true));
      }

      blocTest<ActionsTabBloc, ActionsTabState>(
        'creates the next step docs before reporting success',
        build: () {
          stubMove();
          return bloc;
        },
        act: (bloc) => bloc.add(
          const MoveToNextStep(projectId: 1, processId: 1, nextStepId: 2),
        ),
        verify: (_) {
          verifyInOrder([
            () => mockRepo.moveToNextStep(
              processId: 1,
              projectId: 1,
              nextStepId: 2,
            ),
            () => mockRepo.getCurrentStepDocs(
              projectId: 1,
              processId: 1,
              projectStepId: 2,
            ),
          ]);
        },
      );

      for (final nextStepId in [null, 0]) {
        blocTest<ActionsTabBloc, ActionsTabState>(
          'skips the docs call without a next step ($nextStepId)',
          build: () {
            stubMove();
            return bloc;
          },
          act: (bloc) => bloc.add(
            MoveToNextStep(projectId: 1, processId: 1, nextStepId: nextStepId),
          ),
          expect: () => [
            const MoveToNextStepLoading(),
            isA<MoveToNextStepSuccess>(),
          ],
          verify: (_) {
            verifyNever(
              () => mockRepo.getCurrentStepDocs(
                projectId: any(named: 'projectId'),
                processId: any(named: 'processId'),
                projectStepId: any(named: 'projectStepId'),
              ),
            );
          },
        );
      }

      blocTest<ActionsTabBloc, ActionsTabState>(
        'still succeeds when the next step has no documents',
        build: () {
          stubMove();
          when(
            () => mockRepo.getCurrentStepDocs(
              projectId: any(named: 'projectId'),
              processId: any(named: 'processId'),
              projectStepId: any(named: 'projectStepId'),
            ),
          ).thenThrow(NetworkException('لا يوجد مستندات لهذه الخطوة'));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const MoveToNextStep(projectId: 1, processId: 1, nextStepId: 2),
        ),
        expect: () => [
          const MoveToNextStepLoading(),
          isA<MoveToNextStepSuccess>(),
        ],
      );
    });

    group('SaveComment', () {
      const event = SaveComment(projectId: 1, projectStepId: 2, processId: 3);

      void stubSave(DefaultResponseModel response) {
        when(
          () => mockRepo.addProjectStepComment(
            projectId: any(named: 'projectId'),
            projectStepId: any(named: 'projectStepId'),
            processId: any(named: 'processId'),
            text: any(named: 'text'),
            file: any(named: 'file'),
          ),
        ).thenAnswer((_) async => response);
      }

      blocTest<ActionsTabBloc, ActionsTabState>(
        'ignores an empty comment',
        build: () {
          stubSave(DefaultResponseModel(succeeded: true));
          bloc.commentTEC.text = '   ';
          return bloc;
        },
        act: (bloc) => bloc.add(event),
        expect: () => <ActionsTabState>[],
        verify: (_) {
          verifyNever(
            () => mockRepo.addProjectStepComment(
              projectId: any(named: 'projectId'),
              projectStepId: any(named: 'projectStepId'),
              processId: any(named: 'processId'),
              text: any(named: 'text'),
              file: any(named: 'file'),
            ),
          );
        },
      );

      blocTest<ActionsTabBloc, ActionsTabState>(
        'sends the trimmed text and clears the form on success',
        build: () {
          // The response this endpoint really sends: data is the message.
          stubSave(
            DefaultResponseModel().fromJson({
                  'succeeded': true,
                  'data': 'تمت العملية بنجاح',
                })
                as DefaultResponseModel,
          );
          bloc.commentTEC.text = '  تست  ';
          return bloc;
        },
        act: (bloc) => bloc.add(event),
        expect: () => [const SaveCommentLoading(), isA<SaveCommentSuccess>()],
        verify: (bloc) {
          verify(
            () => mockRepo.addProjectStepComment(
              projectId: 1,
              projectStepId: 2,
              processId: 3,
              text: 'تست',
              file: null,
            ),
          ).called(1);
          expect(bloc.commentTEC.text, isEmpty);
        },
      );

      blocTest<ActionsTabBloc, ActionsTabState>(
        'keeps the text when the server rejects it',
        build: () {
          stubSave(DefaultResponseModel(succeeded: false));
          bloc.commentTEC.text = 'تست';
          return bloc;
        },
        act: (bloc) => bloc.add(event),
        expect: () => [const SaveCommentLoading(), isA<ActionsTabFailure>()],
        verify: (bloc) => expect(bloc.commentTEC.text, 'تست'),
      );
    });
  });
}
