import 'package:project_management/core/utility/pms_exports.dart';

class EditCommentSection extends StatelessWidget {
  final DocumentComment documentComment;
  final int stepDocumentId;

  const EditCommentSection({
    super.key,
    required this.documentComment,
    required this.stepDocumentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocCommentsBloc, DocCommentsState>(
      builder: (context, state) {
        final bloc = context.read<DocCommentsBloc>();
        return Row(
          children: [
            Expanded(
              child: Form(
                key: bloc.formKey,
                child: CustomTextField(
                  verticalPadding: 0,
                  isReadOnly: state is DocCommentsEditing,
                  color: state is DocCommentsEditing
                      ? context.color.outline
                      : null,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  controller: bloc.commentTEC,
                  validation: NotEmptyValidator.notEmptyValidator,
                  suffixWidget: InkWell(
                    onTap: () {
                      bloc.add(
                        EditDocComment(
                          documentId: documentComment.id ?? 0,
                          comment: bloc.commentTEC.text,
                          documentDataId: documentComment.documentDataId ?? 0,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: state is DocCommentsEditing
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: context.color.secondary,
                              ),
                            )
                          : Images(
                              image: Assets.svgs.send.path,
                              color: context.color.secondary,
                            ),
                    ),
                  ),
                  textStyle: context.textTheme.labelSmall,
                  hint:
                      documentComment.text ??
                      '${allTranslations.text(LocaleKeys.add_comment)}...',
                ),
              ),
            ),
            SizedBox(width: 12.w),
            InkWell(
              onTap: () => bloc.add(
                ToggleEditComment(commentId: documentComment.id ?? 0),
              ),
              child: Images(image: Assets.svgs.closeCircle.path, width: 15),
            ),
          ],
        );
      },
    );
  }
}
