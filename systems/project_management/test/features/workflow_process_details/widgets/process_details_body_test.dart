import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/process_details/process_details_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/process_details/process_details_events.dart';
import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';
import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';
import 'package:project_management/features/workflow_process_details/model/stage_doc_model.dart';
import 'package:project_management/features/workflow_process_details/widgets/process_details_body.dart';
import 'package:project_management/shared/model/default_response_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

void main() {
  late MockProcessDetailsRepo repo;
  late ProcessDetailsBloc bloc;
  late String currentStepText;

  setUpAll(initMocktailFallbacks);

  setUp(() {
    repo = MockProcessDetailsRepo();
    currentStepText = 'Before start';

    when(
      () => repo.getGroupSteps(
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
      () => repo.getCurrentNextSteps(
        processId: any(named: 'processId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer(
      (_) async => StageDocResponseModel(
        succeeded: true,
        data:
            StageDocData(
                currentStep: WorkflowStep(id: 1, text: currentStepText),
                workFlowStatus: 'NotStarted',
              )
              ..processTitle = 'Process'
              // Shorter than `yyyy-MM-dd`, which used to throw in the header.
              ..projectStartDate = '2025'
              ..projectEndDate = null,
      ),
    );
    when(
      () => repo.startProcess(
        processId: any(named: 'processId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async {
      currentStepText = 'After start';
      return DefaultResponseModel(succeeded: true);
    });
    when(
      () => repo.getCurrentStepDocs(
        projectId: any(named: 'projectId'),
        processId: any(named: 'processId'),
        projectStepId: any(named: 'projectStepId'),
      ),
    ).thenAnswer((_) async => CurrentStepDocumentModel(succeeded: true));
  });

  // Created inside the test: a bloc made in setUp runs outside the widget
  // test's fake async zone, so its handlers never progress while pumping.
  Future<void> pumpBody(WidgetTester tester) async {
    bloc = ProcessDetailsBloc(repo: repo);
    addTearDown(bloc.close);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const Scaffold(
              body: ProcessDetailsBody(projectId: 1, processId: 1),
            ),
          ),
        ),
      ),
    );
  }

  // The screen has looping animations (shimmers), so it never settles; a few
  // frames are enough for the mocked calls to finish.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  bool headerShows(String step) =>
      find.textContaining(step, findRichText: true).evaluate().isNotEmpty;

  testWidgets('header shows the step the process lands on after starting', (
    tester,
  ) async {
    await pumpBody(tester);
    bloc.add(const LoadGroupSteps(processId: 1, projectId: 1));
    await pumpFrames(tester);

    expect(tester.takeException(), isNull);
    expect(headerShows('Before start'), isTrue);

    bloc.add(const StartProcess(processId: 1, projectId: 1));
    await pumpFrames(tester);

    expect(headerShows('After start'), isTrue);
    expect(headerShows('Before start'), isFalse);
  });
}
