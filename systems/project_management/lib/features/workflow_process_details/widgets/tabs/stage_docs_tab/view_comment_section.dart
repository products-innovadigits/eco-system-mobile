import 'package:project_management/core/utility/project_management_exports.dart';

class ViewCommentSection extends StatelessWidget {
  final DocumentComment documentComment;

  const ViewCommentSection({super.key, required this.documentComment});

  void _confirmDelete(BuildContext context, DocCommentsBloc bloc) {
    showDialog(
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
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DocCommentsBloc>();

    // Rebuild only when a delete/edit request starts or finishes, so the
    // actions can't be triggered twice while one is in flight.
    return BlocSelector<DocCommentsBloc, DocCommentsState, bool>(
      selector: (state) =>
          state is DocCommentsDeleting || state is DocCommentsEditing,
      builder: (context, isBusy) {
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
              onTap: isBusy ? null : () => _confirmDelete(context, bloc),
              child: Images(image: Assets.svgs.trash.path, width: 15),
            ),
            SizedBox(width: 6.w),
            InkWell(
              onTap: isBusy
                  ? null
                  : () => bloc.add(
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
