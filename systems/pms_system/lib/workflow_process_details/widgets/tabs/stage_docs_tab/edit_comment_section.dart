import 'package:pms_system/workflow_process_details/model/document_comments_model.dart';

import '../../../../shared/pms_exports.dart';

class EditCommentSection extends StatelessWidget {
  final DocumentComment documentComment;

  const EditCommentSection({super.key, required this.documentComment});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocCommentsBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<DocCommentsBloc>();
        return Row(
          children: [
            Expanded(
              child: Form(
                key: bloc.formKey,
                child: CustomTextField(
                  verticalPadding: 0,
                  isReadOnly: state is Editing,
                  color: state is Editing ? context.color.outline : null,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  controller: bloc.editCommentCtrl,
                  validation: NotEmptyValidator.notEmptyValidator,
                  suffixWidget: InkWell(
                    onTap: () {
                      bloc.add(
                        Edit(
                          documentId: documentComment.id ?? 0,
                          comment: bloc.editCommentCtrl.text,
                          documentDataId:
                          documentComment.documentDataId ?? 0,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: state is Editing
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
            const SizedBox(width: 12),
            InkWell(
              onTap: () => bloc.add(Toggle(arguments: documentComment.id ?? 0)),
              child: Images(image: Assets.svgs.closeCircle.path, width: 15),
            ),
          ],
        );
      },
    );
  }
}
