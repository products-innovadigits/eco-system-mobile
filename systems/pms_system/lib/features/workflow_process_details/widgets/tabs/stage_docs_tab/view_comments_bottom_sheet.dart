import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/doc_comments/doc_comments_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/doc_comments/doc_comments_state.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/stage_docs_tab/edit_comment_section.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/stage_docs_tab/view_comment_section.dart';

class ViewCommentsBottomSheet extends StatelessWidget {
  final int stepDocumentId;

  const ViewCommentsBottomSheet({super.key, required this.stepDocumentId});

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
          DocCommentsLoaded(:final commentsData) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
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
                        stepDocumentId: stepDocumentId,
                      )
                    : ViewCommentSection(
                        documentComment: documentComment,
                        stepDocumentId: stepDocumentId,
                      ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemCount: commentsData.items?.length ?? 0,
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
