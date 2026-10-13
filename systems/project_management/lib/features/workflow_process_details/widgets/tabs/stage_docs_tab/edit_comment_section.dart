import 'package:project_management/core/utility/project_management_exports.dart';

class EditCommentSection extends StatelessWidget {
  final DocumentComment documentComment;

  const EditCommentSection({super.key, required this.documentComment});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DocCommentsBloc>();
    final commentId = documentComment.id ?? 0;

    // Rebuild only when editing starts or stops.
    return BlocSelector<DocCommentsBloc, DocCommentsState, bool>(
      selector: (state) => state is DocCommentsEditing,
      builder: (context, isEditing) {
        return Row(
          children: [
            Expanded(
              child: CustomTextField(
                verticalPadding: 0,
                isReadOnly: isEditing,
                color: isEditing ? context.color.outline : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                controller: bloc.commentTEC,
                suffixWidget: SendCommentButton(
                  controller: bloc.commentTEC,
                  isLoading: isEditing,
                  onSend: () => bloc.add(
                    EditDocComment(
                      documentId: commentId,
                      comment: bloc.commentTEC.text.trim(),
                      documentDataId: documentComment.documentDataId ?? 0,
                    ),
                  ),
                ),
                textStyle: context.textTheme.labelSmall,
                hint:
                    documentComment.text ??
                    '${allTranslations.text(LocaleKeys.add_comment)}...',
              ),
            ),
            SizedBox(width: 12.w),
            InkWell(
              onTap: isEditing
                  ? null
                  : () => bloc.add(ToggleEditComment(commentId: commentId)),
              child: Images(image: Assets.svgs.closeCircle.path, width: 15),
            ),
          ],
        );
      },
    );
  }
}
