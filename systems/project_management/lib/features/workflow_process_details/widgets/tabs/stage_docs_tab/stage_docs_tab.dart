import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class StageDocsTab extends StatelessWidget {
  final String processName;
  final List<StageDocument> documents;

  const StageDocsTab({
    super.key,
    required this.processName,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return EmptyContainer(txt: allTranslations.text(LocaleKeys.no_docs));
    }

    return BlocProvider(
      create: (_) => DocCommentsBloc(repo: projectManagementSl()),
      child: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) =>
            _StageDocCard(document: documents[index], processName: processName),
      ),
    );
  }
}

class _StageDocCard extends StatelessWidget {
  final StageDocument document;
  final String processName;

  const _StageDocCard({required this.document, required this.processName});

  @override
  Widget build(BuildContext context) {
    final documentId = document.documentCopyId ?? 0;

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.color.outline),
      ),
      child: Column(
        children: [
          _DocCardHeader(document: document),
          SizedBox(height: 8.h),
          _OperationNameRow(processName: processName),
          if (documentId != 0) ...[
            SizedBox(height: 10.h),
            _AddCommentField(documentId: documentId),
          ],
        ],
      ),
    );
  }
}

class _DocCardHeader extends StatelessWidget {
  final StageDocument document;

  const _DocCardHeader({required this.document});

  void _showHtmlContent(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => HtmlContentDialog(document: document),
    );
  }

  void _showComments(BuildContext context) {
    final documentId = document.documentCopyId ?? 0;
    final docCommentsBloc = context.read<DocCommentsBloc>()
      ..add(LoadDocComments(documentId: documentId));

    PopUpHelper.showBottomSheet(
      header: allTranslations.text(LocaleKeys.view_comments),
      child: BlocProvider.value(
        value: docCommentsBloc,
        child: const ViewCommentsBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            document.documentTitle ?? '',
            style: context.textTheme.labelSmall,
          ),
        ),
        SizedBox(width: 8.w),
        _DocActionCardWidget(
          icon: Assets.svgs.exporting.path,
          onTap: () => _showHtmlContent(context),
        ),
        SizedBox(width: 4.w),
        _DocActionCardWidget(
          icon: Assets.svgs.eye.path,
          onTap: () => _showComments(context),
        ),
      ],
    );
  }
}

class _OperationNameRow extends StatelessWidget {
  final String processName;

  const _OperationNameRow({required this.processName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.color.secondary.withValues(alpha: 0.1),
          ),
          child: Images(
            image: Assets.svgs.setting.path,
            color: context.color.secondary,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                allTranslations.text(LocaleKeys.operation_name),
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: FontSizes.f10,
                  color: context.color.outlineVariant,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                processName,
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: FontSizes.f10,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddCommentField extends StatelessWidget {
  final int documentId;

  const _AddCommentField({required this.documentId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StageDocsBloc>();
    final controller = bloc.getCommentController(documentId);

    // Rebuild only when this document starts or stops adding a comment.
    return BlocSelector<StageDocsBloc, StageDocsState, bool>(
      selector: (state) =>
          state is StageDocsAdding && state.stepDocumentId == documentId,
      builder: (context, isAdding) {
        return CustomTextField(
          verticalPadding: 0,
          isReadOnly: isAdding,
          color: isAdding ? context.color.outline : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          controller: controller,
          suffixWidget: SendCommentButton(
            controller: controller,
            isLoading: isAdding,
            onSend: () => bloc.add(
              AddDocumentComment(
                stepDocumentId: documentId,
                text: controller.text.trim(),
              ),
            ),
          ),
          textStyle: context.textTheme.labelSmall,
          hint: '${allTranslations.text(LocaleKeys.add_comment)}...',
        );
      },
    );
  }
}

class _DocActionCardWidget extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _DocActionCardWidget({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: context.color.outline),
        ),
        child: Images(image: icon, color: context.color.primary, width: 14),
      ),
    );
  }
}
