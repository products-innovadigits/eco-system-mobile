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
            () => mockRepo.getDocComments(
              documentId: any(named: 'documentId'),
              pageIndex: any(named: 'pageIndex'),
              pageSize: any(named: 'pageSize'),
            ),
          ).thenAnswer(
            (_) async => DocumentCommentsModel(
              succeeded: true,
              data: CommentsData(
                items: [DocumentComment(id: 1, text: 'Test Comment')],
                totalCount: 1,
                currentPage: 1,
                totalPages: 1,
              ),
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadDocComments(documentId: 1)),
        expect: () => [const DocCommentsLoading(), isA<DocCommentsLoaded>()],
        verify: (_) {
          verify(
            () => mockRepo.getDocComments(
              documentId: 1,
              pageIndex: 1,
              pageSize: 10,
            ),
          ).called(1);
        },
      );

      blocTest<DocCommentsBloc, DocCommentsState>(
        'emits [DocCommentsLoading, DocCommentsEmpty] when repo returns empty data',
        build: () {
          when(
            () => mockRepo.getDocComments(
              documentId: any(named: 'documentId'),
              pageIndex: 1,
              pageSize: any(named: 'pageSize'),
            ),
          ).thenAnswer(
            (_) async => DocumentCommentsModel(
              succeeded: true,
              data: CommentsData(items: [], totalCount: 0, currentPage: 1, totalPages: 1),
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
            () => mockRepo.getDocComments(
              documentId: any(named: 'documentId'),
              pageIndex: any(named: 'pageIndex'),
              pageSize: any(named: 'pageSize'),
            ),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadDocComments(documentId: 1)),
        expect: () => [const DocCommentsLoading(), isA<DocCommentsFailure>()],
      );
    });

    group('LoadMoreDocComments', () {
      blocTest<DocCommentsBloc, DocCommentsState>(
        'emits [DocCommentsLoaded] with new data when loading more',
        build: () {
          // Mock initial load
          when(
            () => mockRepo.getDocComments(
              documentId: 1,
              pageIndex: 1,
              pageSize: 10,
            ),
          ).thenAnswer(
            (_) async => DocumentCommentsModel(
              succeeded: true,
              data: CommentsData(
                items: [DocumentComment(id: 1, text: 'Comment 1')],
                totalCount: 2,
                currentPage: 1,
                totalPages: 2,
              ),
            ),
          );
          // Mock load more
          when(
            () => mockRepo.getDocComments(
              documentId: 1,
              pageIndex: 2,
              pageSize: 10,
            ),
          ).thenAnswer(
            (_) async => DocumentCommentsModel(
              succeeded: true,
              data: CommentsData(
                items: [DocumentComment(id: 2, text: 'Comment 2')],
                totalCount: 2,
                currentPage: 2,
                totalPages: 2,
                isLastPage: true,
              ),
            ),
          );
          return bloc;
        },
        act: (bloc) async {
          bloc.add(const LoadDocComments(documentId: 1));
          await Future.delayed(Duration.zero);
          bloc.add(const LoadMoreDocComments());
        },
        skip: 2, // Skip initial loading and loaded states
        expect: () => [
          isA<DocCommentsLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
          isA<DocCommentsLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', false).having((s) => s.commentsData.items?.length, 'items count', 2),
        ],
      );
    });
  });
}
