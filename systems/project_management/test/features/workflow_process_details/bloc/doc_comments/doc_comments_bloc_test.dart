import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/bloc/doc_comments/doc_comments_bloc.dart';
import 'package:project_management/features/workflow_process_details/bloc/doc_comments/doc_comments_events.dart';
import 'package:project_management/features/workflow_process_details/bloc/doc_comments/doc_comments_state.dart';
import 'package:project_management/features/workflow_process_details/model/document_comments_model.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProcessDetailsRepo mockRepo;
  late DocCommentsBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProcessDetailsRepo();
    bloc = DocCommentsBloc(repo: mockRepo);
  });

  tearDown(() {
  });

  group('DocCommentsBloc', () {
    group('LoadDocComments', () {
      blocTest<DocCommentsBloc, DocCommentsState>(
        'emits [DocCommentsLoading, DocCommentsLoaded] when repo returns data',
        build: () {
          when(
            () => mockRepo.getDocComments(documentId: any(named: 'documentId')),
          ).thenAnswer(
            (_) async => DocumentCommentsModel(
              succeeded: true,
              data: CommentsData(
                items: [DocumentComment(id: 1, text: 'Test Comment')],
                totalCount: 1,
              ),
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadDocComments(documentId: 1)),
        expect: () => [const DocCommentsLoading(), isA<DocCommentsLoaded>()],
        verify: (_) {
          verify(() => mockRepo.getDocComments(documentId: 1)).called(1);
        },
      );

      blocTest<DocCommentsBloc, DocCommentsState>(
        'emits [DocCommentsLoading, DocCommentsEmpty] when repo returns empty data',
        build: () {
          when(
            () => mockRepo.getDocComments(documentId: any(named: 'documentId')),
          ).thenAnswer(
            (_) async => DocumentCommentsModel(
              succeeded: true,
              data: CommentsData(items: [], totalCount: 0),
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadDocComments(documentId: 1)),
        expect: () => [const DocCommentsLoading(), isA<DocCommentsEmpty>()],
      );

      blocTest<DocCommentsBloc, DocCommentsState>(
        'emits [DocCommentsLoading, DocCommentsFailure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getDocComments(documentId: any(named: 'documentId')),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadDocComments(documentId: 1)),
        expect: () => [const DocCommentsLoading(), isA<DocCommentsFailure>()],
      );
    });
  });
}
