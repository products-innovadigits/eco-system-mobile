import 'package:pms_system/workflow_process_details/model/current_step_document_model.dart';

import '../../../../shared/pms_exports.dart';

class StageDocsTab extends StatelessWidget {
  final int processId;
  final int projectId;
  final String pdfFilePath;
  final String processName;

  const StageDocsTab({
    super.key,
    required this.processId,
    required this.projectId,
    required this.pdfFilePath,
    required this.processName,
  });

  void _showHtmlContent(BuildContext context, StepDocument document) {
    showDialog(
      context: context,
      builder: (context) =>
          HtmlContentDialog(document: document, pdfFilePath: pdfFilePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DocCommentsBloc()),
        BlocProvider(
          create: (context) => StageDocsBloc()
            ..add(
              Click(
                arguments: {
                  'processId': processId,
                  'projectId': projectId,
                  'projectStepId': context
                      .read<WorkflowProcessDetailsBloc>()
                      .stageDocsData
                      ?.currentStep
                      ?.id,
                },
              ),
            ),
        ),
      ],
      child: BlocBuilder<StageDocsBloc, AppState>(
        buildWhen: (previous, current) => current is! Adding,
        builder: (context, state) {
          final docCommentsBloc = context.read<DocCommentsBloc>();
          return switch (state) {
            // ── Loading ─────────────────────────
            Loading() || Start() => _buildShimmerLoading(context),

            // ── Done ────────────────────────────
            Done(:final data) => (() {
              final CurrentStepDocumentData? model =
                  data as CurrentStepDocumentData?;
              final documents = model?.items ?? [];
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final CurrentStepDocumentItem document = documents[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: context.color.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.color.outline),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                document.document?.documentTitle ?? '',
                                style: context.textTheme.labelSmall,
                              ),
                            ),
                            _DocActionCardWidget(
                              icon: Assets.svgs.exporting.path,
                              onTap: () =>
                                  _showHtmlContent(context, document.document!),
                            ),
                            SizedBox(width: 4),
                            _DocActionCardWidget(
                              icon: Assets.svgs.eye.path,
                              onTap: () {
                                docCommentsBloc.add(
                                  Click(arguments: document.id),
                                );
                                PopUpHelper.showBottomSheet(
                                  child: BlocProvider.value(
                                    value: docCommentsBloc,
                                    child: ViewCommentsBottomSheet(
                                      stepDocumentId: document.id ?? 0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.color.secondary.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              child: Images(
                                image: Assets.svgs.setting.path,
                                color: context.color.secondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allTranslations.text(
                                    LocaleKeys.operation_name,
                                  ),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontSize: FontSizes.f10,
                                    color: context.color.outlineVariant,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  processName,
                                  style: context.textTheme.labelSmall?.copyWith(
                                    fontSize: FontSizes.f10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<StageDocsBloc, AppState>(
                          builder: (context, state) {
                            final bloc = context.read<StageDocsBloc>();
                            final documentId = document.id ?? 0;
                            final formKey = bloc.getFormKey(documentId);
                            final controller = bloc.getCommentController(documentId);
                            final isAdding = state is Adding;
                            
                            if (formKey == null || controller == null || documentId == 0) {
                              return const SizedBox.shrink();
                            }
                            
                            return Form(
                              key: formKey,
                              child: CustomTextField(
                                verticalPadding: 0,
                                isReadOnly: isAdding,
                                color: isAdding
                                    ? context.color.outline
                                    : null,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                controller: controller,
                                validation: NotEmptyValidator.notEmptyValidator,
                                suffixWidget: InkWell(
                                  onTap: () {
                                    bloc.add(
                                      AddDocumentComment(
                                        stepDocumentId: documentId,
                                        text: controller.text,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: isAdding
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
                                    '${allTranslations.text(LocaleKeys.add_comment)}...',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            })(),

            // ── Empty ───────────────────────────
            Empty() => EmptyContainer(
              txt: allTranslations.text(LocaleKeys.no_docs),
            ),

            // ── Error / fallback ────────────────
            _ => EmptyContainer(
              txt: allTranslations.text(LocaleKeys.something_went_wrong),
              img: Assets.svgs.error.path,
            ),
          };
        },
      ),
    );
  }
}

Widget _buildShimmerLoading(BuildContext context) => Column(
  children: List.generate(
    3,
    (_) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomShimmerContainer(height: 130, width: double.infinity),
    ),
  ),
);

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
        padding: EdgeInsets.all(2),
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
