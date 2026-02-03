import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/stage_docs/stage_docs_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/stage_docs/stage_docs_events.dart';
import 'package:project_management/features/workflow_process_details/bloc/stage_docs/stage_docs_state.dart';
import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProcessDetailsRepo mockRepo;
  late StageDocsBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProcessDetailsRepo();
    bloc = StageDocsBloc(repo: mockRepo);
  });

  tearDown(() {
  });

  group('StageDocsBloc', () {
    group('CreateCurrentStepDocs', () {
      blocTest<StageDocsBloc, StageDocsState>(
        'emits [StageDocsLoading, StageDocsLoaded] when repo returns success',
        build: () {
          when(
            () => mockRepo.getCurrentStepDocs(
              projectId: any(named: 'projectId'),
              projectStepId: any(named: 'projectStepId'),
              processId: any(named: 'processId'),
            ),
          ).thenAnswer((_) async => CurrentStepDocumentModel(succeeded: true));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const CreateCurrentStepDocs(
            processId: 1,
            projectId: 1,
            projectStepId: 1,
          ),
        ),
        expect: () => [const StageDocsLoading(), isA<StageDocsLoaded>()],
        verify: (_) {
          verify(
            () => mockRepo.getCurrentStepDocs(
              projectId: 1,
              projectStepId: 1,
              processId: 1,
            ),
          ).called(1);
        },
      );

      blocTest<StageDocsBloc, StageDocsState>(
        'emits [StageDocsLoading, StageDocsFailure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getCurrentStepDocs(
              projectId: any(named: 'projectId'),
              projectStepId: any(named: 'projectStepId'),
              processId: any(named: 'processId'),
            ),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const CreateCurrentStepDocs(
            processId: 1,
            projectId: 1,
            projectStepId: 1,
          ),
        ),
        expect: () => [const StageDocsLoading(), isA<StageDocsFailure>()],
      );
    });
  });
}
