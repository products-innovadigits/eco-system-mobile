import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/process_details/process_details_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/process_details/process_details_events.dart';
import 'package:project_management/features/workflow_process_details/bloc/process_details/process_details_state.dart';
import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';
import 'package:project_management/features/workflow_process_details/model/stage_doc_model.dart';

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

  tearDown(() {
  });

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
  });
}
