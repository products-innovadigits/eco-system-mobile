import 'package:project_management/core/utility/project_management_exports.dart';

class ViewCommentsBottomSheet extends StatefulWidget {
  const ViewCommentsBottomSheet({super.key});

  @override
  State<ViewCommentsBottomSheet> createState() =>
      _ViewCommentsBottomSheetState();
}

class _ViewCommentsBottomSheetState extends State<ViewCommentsBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bloc = context.read<DocCommentsBloc>();
    final state = bloc.state;
    // Avoid flooding the bloc with events on every scroll tick.
    if (state is! DocCommentsLoaded || !state.hasMore || state.isLoadingMore) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 100) {
      bloc.add(const LoadMoreDocComments());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocCommentsBloc, DocCommentsState>(
      // Deleting/editing progress is handled inside each comment row.
      buildWhen: (previous, current) =>
          current is! DocCommentsDeleting && current is! DocCommentsEditing,
      builder: (context, state) {
        return switch (state) {
          // ── Loading ─────────────────────────
          DocCommentsInitial() ||
          DocCommentsLoading() => const _CommentsShimmer(),

          // ── Loaded ──────────────────────────
          DocCommentsLoaded(:final commentsData, :final isLoadingMore) =>
            _buildCommentsList(commentsData.items ?? const [], isLoadingMore),

          // ── Empty ───────────────────────────
          DocCommentsEmpty() => EmptyContainer(
            remain: 400,
            txt: allTranslations.text(LocaleKeys.no_comments),
          ),

          // ── Error / fallback ────────────────
          _ => EmptyContainer(
            txt: allTranslations.text(LocaleKeys.something_went_wrong),
            img: Assets.svgs.error.path,
          ),
        };
      },
    );
  }

  Widget _buildCommentsList(
    List<DocumentComment> comments,
    bool isLoadingMore,
  ) {
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: comments.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        if (index == comments.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final comment = comments[index];
        return _CommentCard(key: ValueKey(comment.id), comment: comment);
      },
    );
  }
}

class _CommentCard extends StatelessWidget {
  final DocumentComment comment;

  const _CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final isEditing = context.read<DocCommentsBloc>().isCommentBeingEdited(
      comment.id ?? 0,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.color.outline),
      ),
      child: isEditing
          ? EditCommentSection(documentComment: comment)
          : ViewCommentSection(documentComment: comment),
    );
  }
}

class _CommentsShimmer extends StatelessWidget {
  const _CommentsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomShimmerContainer(height: 60, width: double.infinity),
        ),
      ),
    );
  }
}
