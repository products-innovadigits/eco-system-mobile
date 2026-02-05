import 'package:project_management/core/utility/pms_exports.dart';
import 'package:project_management/shared/model/default_response_model.dart';

class DocCommentsBloc extends Bloc<DocCommentsEvent, DocCommentsState> {
  final ProcessDetailsRepo repo;
  final bool _ownsController;

  DocCommentsBloc({
    required this.repo,
    TextEditingController? commentController,
  })  : _ownsController = commentController == null,
        commentTEC = commentController ?? TextEditingController(),
        super(const DocCommentsInitial()) {
    on<DeleteDocComment>(_onDeleteDocumentComment);
    on<EditDocComment>(_onEditDocumentComment);
    on<LoadDocComments>(_onLoadDocComments);
    on<LoadMoreDocComments>(_onLoadMoreDocComments);
    on<ToggleEditComment>(_onToggleEditDocumentComment);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController commentTEC;
  int? _editingCommentId; // Track which comment is being edited
  CommentsData? _commentsData;
  final List<DocumentComment> _comments = [];
  SearchEngine _engine = SearchEngine();
  int? _currentDocId;
  bool _isLoadingMore = false;

  // Check if a specific comment is being edited
  bool isCommentBeingEdited(int commentId) => _editingCommentId == commentId;

  Future<void> _onLoadDocComments(
    LoadDocComments event,
    Emitter<DocCommentsState> emit,
  ) async {
    _currentDocId = event.documentId;
    _comments.clear();
    _engine = SearchEngine(currentPage: 0, maxPages: 1);
    
    emit(const DocCommentsLoading());
    await _fetchComments(emit);
  }

  Future<void> _onLoadMoreDocComments(
    LoadMoreDocComments event,
    Emitter<DocCommentsState> emit,
  ) async {
    if (_isLoadingMore || !_engine.hasMorePages || _currentDocId == null) {
      return;
    }

    _isLoadingMore = true;
    _engine.updateCurrentPage(_engine.currentPage + 1);
    
    // Emit loaded state with isLoadingMore: true to show bottom indicator
    if (_commentsData != null) {
      emit(DocCommentsLoaded(
        commentsData: _commentsData!.copyWith(items: _comments),
        isLoadingMore: true,
        currentPage: _engine.currentPage,
        totalPages: _engine.maxPages,
        hasMore: _engine.hasMorePages,
      ));
    }

    await _fetchComments(emit);
  }

  Future<void> _fetchComments(Emitter<DocCommentsState> emit) async {
    if (_currentDocId == null) return;

    try {
      DocumentCommentsModel res = await repo.getDocComments(
        documentId: _currentDocId!,
        pageIndex: _engine.nextPageIndex,
        pageSize: _engine.limit,
      );

      _isLoadingMore = false;

      if (res.succeeded == true && res.data != null) {
        final newItems = res.data!.items ?? [];
        
        if (_engine.currentPage == 0) {
          _comments.clear();
        }
        _comments.addAll(newItems);
        _commentsData = res.data;

        // Sync pagination info from API response
        if (res.data!.currentPage != null && res.data!.totalPages != null) {
          _engine.syncPaginationFromApi(
            apiCurrentPage: res.data!.currentPage!,
            totalPages: res.data!.totalPages!,
            totalCount: res.data!.totalCount ?? 0,
            pageSize: res.data!.pageSize,
            isLastPage: res.data!.isLastPage,
          );
        }

        if (_comments.isNotEmpty) {
          if (_engine.currentPage == 0) {
            _editingCommentId = null;
            commentTEC.clear();
          }
          emit(DocCommentsLoaded(
            commentsData: _commentsData!.copyWith(items: _comments),
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ));
        } else {
          if (_engine.currentPage == 0) {
            emit(const DocCommentsEmpty());
          } else {
             emit(DocCommentsLoaded(
                commentsData: _commentsData!.copyWith(items: _comments),
                isLoadingMore: false,
                currentPage: _engine.currentPage,
                totalPages: _engine.maxPages,
                hasMore: _engine.hasMorePages,
              ));
          }
        }
      } else {
        if (_comments.isEmpty) {
          emit(const DocCommentsEmpty());
        } else {
          emit(DocCommentsLoaded(
            commentsData: _commentsData!.copyWith(items: _comments),
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ));
        }
      }
    } catch (e) {
      _isLoadingMore = false;
      if (_comments.isEmpty) {
        emit(const DocCommentsFailure());
      } else {
        emit(DocCommentsLoaded(
          commentsData: _commentsData!.copyWith(items: _comments),
          isLoadingMore: false,
          currentPage: _engine.currentPage,
          totalPages: _engine.maxPages,
          hasMore: _engine.hasMorePages,
        ));
      }
    }
  }

  void _onDeleteDocumentComment(
    DeleteDocComment event,
    Emitter<DocCommentsState> emit,
  ) async {
    emit(const DocCommentsDeleting());
    try {
      // Delete comment using the document ID
      DefaultResponseModel response = await repo.deleteDocComment(
        documentId: event.commentId,
      );

      if (response.succeeded == true) {
        AppCore.successToastMessage(
          response.data?.message ?? 'Comment deleted successfully',
        );
        add(LoadDocComments(documentId: event.documentId));
      } else {
        AppCore.errorToastMessage(
          response.data?.message ?? 'Failed to delete comment',
        );
        _reEmitLoaded(emit);
      }
    } catch (e) {
      _reEmitLoaded(emit);
    }
  }

  void _onEditDocumentComment(
    EditDocComment event,
    Emitter<DocCommentsState> emit,
  ) async {
    if (!formKey.currentState!.validate()) return;
    emit(const DocCommentsEditing());
    try {
      DefaultResponseModel response = await repo.editDocComment(
        documentId: event.documentId,
        documentDataId: event.documentDataId,
        text: event.comment,
      );

      if (response.succeeded == true) {
        add(LoadDocComments(documentId: event.documentDataId));
        commentTEC.clear();
        _editingCommentId = null;
        AppCore.successToastMessage(
          response.data?.message ?? 'Comment edited successfully',
        );
      } else {
        AppCore.errorToastMessage(
          response.data?.message ?? 'Failed to edit comment',
        );
        _reEmitLoaded(emit);
      }
    } catch (e) {
      _reEmitLoaded(emit);
    }
  }

  void _onToggleEditDocumentComment(
    ToggleEditComment event,
    Emitter<DocCommentsState> emit,
  ) async {
    int commentId = event.commentId;

    if (_editingCommentId == commentId) {
      // If this comment is already being edited, stop editing
      _editingCommentId = null;
      commentTEC.clear();
    } else {
      // If a different comment is being edited, switch to this one
      _editingCommentId = commentId;
      // Set the current text in the controller
      final comment = _comments.firstWhere(
        (c) => c.id == commentId,
        orElse: () => DocumentComment(),
      );
      commentTEC.text = comment.text ?? '';
    }

    _reEmitLoaded(emit);
  }

  void _reEmitLoaded(Emitter<DocCommentsState> emit) {
    if (_commentsData != null) {
      emit(DocCommentsLoaded(
        commentsData: _commentsData!.copyWith(items: _comments),
        isLoadingMore: false,
                currentPage: _engine.currentPage,
                totalPages: _engine.maxPages,
                hasMore: _engine.hasMorePages,
      ));
    } else {
      emit(const DocCommentsInitial());
    }
  }

  @override
  Future<void> close() {
    if (_ownsController) {
      commentTEC.dispose();
    }
    return super.close();
  }
}

extension on CommentsData {
  CommentsData copyWith({List<DocumentComment>? items}) {
    return CommentsData(
      items: items ?? this.items,
      currentPage: currentPage,
      pageSize: pageSize,
      totalPages: totalPages,
      nextPage: nextPage,
      previousPage: previousPage,
      isLastPage: isLastPage,
      totalCount: totalCount,
    );
  }
}
