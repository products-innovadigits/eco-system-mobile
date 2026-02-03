import 'package:project_management/core/utility/pms_exports.dart';

class ViewCommentSection extends StatelessWidget {
  final DocumentComment documentComment;
  final int stepDocumentId;

  const ViewCommentSection({
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
              child: Text(
                documentComment.text ?? '',
                style: context.textTheme.labelSmall,
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: () => _onDeleteComment(context, bloc, documentComment),
              child: Images(image: Assets.svgs.trash.path, width: 15),
            ),
            SizedBox(width: 6.w),
            InkWell(
              onTap: () => bloc.add(
                ToggleEditComment(commentId: documentComment.id ?? 0),
              ),
              child: Images(image: Assets.svgs.editSquare.path, width: 15),
            ),
          ],
        );
      },
    );
  }
}

// anas.taher@innovaDigits.com
// 1020304050Aa

void _onDeleteComment(
  BuildContext context,
  DocCommentsBloc bloc,
  DocumentComment documentComment,
) => showDialog(
  context: context,
  builder: (_) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    title: Images(image: Assets.svgs.trash.path, width: 28, height: 28),
    content: Text(
      allTranslations.text(LocaleKeys.delete),
      textAlign: TextAlign.center,
    ),
    actions: [
      Row(
        children: [
          Expanded(
            child: CustomBtn(
              text: allTranslations.text(LocaleKeys.cancel),
              height: 40,
              color: context.color.surfaceContainer,
              borderColor: context.color.primary,
              textColor: context.color.primary,
              onPressed: () => CustomNavigator.pop(),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomBtn(
              text: allTranslations.text(LocaleKeys.delete),
              height: 40,
              onPressed: () {
                CustomNavigator.pop();
                bloc.add(
                  DeleteDocComment(
                    documentId: documentComment.documentDataId ?? 0,
                    commentId: documentComment.id ?? 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ],
  ),
);
