import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/model/document_comments_model.dart';
import 'package:pms_system/workflow_process_details/widgets/tabs/stage_docs_tab/edit_comment_section.dart';
import 'package:pms_system/workflow_process_details/widgets/tabs/stage_docs_tab/view_comment_section.dart';

class ViewCommentsBottomSheet extends StatelessWidget {
  final int stepDocumentId;

  const ViewCommentsBottomSheet({super.key, required this.stepDocumentId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocCommentsBloc, AppState>(
      buildWhen: (previous, current) =>
          current is! Deleting && current is! Editing,
      builder: (context, state) {
        final bloc = context.read<DocCommentsBloc>();
        return switch (state) {
          // ── Loading ─────────────────────────
          Loading() => _buildingShimmerList(),

          // ── Done ────────────────────────────
          Done(:final data) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final documentComment = (data).items![index];

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
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: (data as CommentsData).items?.length ?? 0,
          ),

          // ── Empty ───────────────────────────
          Empty() => EmptyContainer(
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
