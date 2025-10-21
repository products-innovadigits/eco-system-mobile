import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/model/document_comments_model.dart';
import 'package:pms_system/workflow_process_details/widgets/tabs/stage_docs_tab/edit_comment_section.dart';
import 'package:pms_system/workflow_process_details/widgets/tabs/stage_docs_tab/view_comment_section.dart';

class ViewCommentsBottomSheet extends StatelessWidget {
  const ViewCommentsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(
          title: allTranslations.text(LocaleKeys.view_comments),
        ),
        const SizedBox(height: 24),
        BlocBuilder<DocCommentsBloc, AppState>(
          buildWhen: (previous, current) =>
              current is! Deleting && current is! Editing,
          builder: (context, state) {
            final bloc = context.read<DocCommentsBloc>();
            return switch (state) {
              // ── Loading ─────────────────────────
              Loading() => _buildingShimmerList(),

              // ── Done ────────────────────────────
              Done(:final data) => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ListAnimator(
                      separatorPadding: 12,
                      data: List.generate(
                        ((data as CommentsData?)?.items ?? []).length,
                        (index) {
                          final DocumentComment documentComment =
                              (data as CommentsData).items?[index] ??
                              DocumentComment();
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: context.color.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: context.color.outline),
                            ),
                            child:
                                bloc.isCommentBeingEdited(
                                  documentComment.id ?? 0,
                                )
                                ? EditCommentSection(
                                    documentComment: documentComment,
                                  )
                                : ViewCommentSection(
                                    documentComment: documentComment,
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: CustomBtn(
                  //     text: allTranslations.text(LocaleKeys.save),
                  //     onPressed: () => CustomNavigator.pop(),
                  //   ),
                  // ),
                ],
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
        ),
      ],
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
