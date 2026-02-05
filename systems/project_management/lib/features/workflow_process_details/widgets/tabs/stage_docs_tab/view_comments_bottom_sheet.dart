import 'package:project_management/core/utility/pms_exports.dart';

class ViewCommentsBottomSheet extends StatefulWidget {
  final int stepDocumentId;

  const ViewCommentsBottomSheet({super.key, required this.stepDocumentId});

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<DocCommentsBloc>().add(const LoadMoreDocComments());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocCommentsBloc, DocCommentsState>(
      buildWhen: (previous, current) =>
          current is! DocCommentsDeleting && current is! DocCommentsEditing,
      builder: (context, state) {
        final bloc = context.read<DocCommentsBloc>();
        return switch (state) {
          // ── Loading ─────────────────────────
          DocCommentsLoading() => _buildingShimmerList(),

          // ── Loaded ────────────────────────────
          DocCommentsLoaded(
            :final commentsData,
            :final isLoadingMore,
          ) => ListView.separated(
            controller: _scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index < (commentsData.items?.length ?? 0)) {
                final documentComment = commentsData.items![index];

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: context.color.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.color.outline),
                  ),
                  child: bloc.isCommentBeingEdited(documentComment.id ?? 0)
                      ? EditCommentSection(
                          documentComment: documentComment,
                          stepDocumentId: widget.stepDocumentId,
                        )
                      : ViewCommentSection(
                          documentComment: documentComment,
                          stepDocumentId: widget.stepDocumentId,
                        ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
            },
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemCount: (commentsData.items?.length ?? 0) + (isLoadingMore ? 1 : 0),
          ),

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

  Widget _buildingShimmerList() {
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
