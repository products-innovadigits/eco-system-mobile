import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/stage_docs/stage_docs_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/stage_docs/stage_docs_events.dart';
import 'package:project_management/features/workflow_process_details/bloc/stage_docs/stage_docs_state.dart';
import 'package:project_management/shared/model/default_response_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProcessDetailsRepo mockRepo;
  late StageDocsBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
    // The bloc shows a toast on success; the plugin has no platform here.
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('PonnamKarthik/fluttertoast'),
          (_) async => true,
        );
  });

  setUp(() {
    mockRepo = MockProcessDetailsRepo();
    bloc = StageDocsBloc(repo: mockRepo);
  });

  tearDown(() {});

  group('StageDocsBloc', () {
    group('AddDocumentComment', () {
      blocTest<StageDocsBloc, StageDocsState>(
        'emits [StageDocsAdding, StageDocsLoaded] and clears the field on success',
        build: () {
          when(
            () => mockRepo.addDocComment(
              documentId: any(named: 'documentId'),
              text: any(named: 'text'),
            ),
          ).thenAnswer((_) async => DefaultResponseModel(succeeded: true));
          bloc.getCommentController(7).text = 'Looks good';
          return bloc;
        },
        act: (bloc) => bloc.add(
          const AddDocumentComment(stepDocumentId: 7, text: 'Looks good'),
        ),
        expect: () => [
          isA<StageDocsAdding>().having(
            (s) => s.stepDocumentId,
            'stepDocumentId',
            7,
          ),
          isA<StageDocsLoaded>(),
        ],
        verify: (bloc) {
          verify(
            () => mockRepo.addDocComment(documentId: 7, text: 'Looks good'),
          ).called(1);
          expect(bloc.getCommentController(7).text, isEmpty);
        },
      );

      blocTest<StageDocsBloc, StageDocsState>(
        'emits [StageDocsAdding, StageDocsFailure] and keeps the text when the call throws',
        build: () {
          when(
            () => mockRepo.addDocComment(
              documentId: any(named: 'documentId'),
              text: any(named: 'text'),
            ),
          ).thenThrow(NetworkException('Network error'));
          bloc.getCommentController(7).text = 'Looks good';
          return bloc;
        },
        act: (bloc) => bloc.add(
          const AddDocumentComment(stepDocumentId: 7, text: 'Looks good'),
        ),
        expect: () => [isA<StageDocsAdding>(), isA<StageDocsFailure>()],
        verify: (bloc) {
          expect(bloc.getCommentController(7).text, 'Looks good');
        },
      );
    });
  });
}
