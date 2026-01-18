import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/doc_comments/doc_comments_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/doc_comments/doc_comments_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_state.dart';
import 'package:pms_system/features/workflow_process_details/bloc/workflow_process_details/workflow_process_details_bloc.dart';
import 'package:pms_system/features/workflow_process_details/model/current_step_document_model.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/html_content_dialog.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/stage_docs_tab/view_comments_bottom_sheet.dart';

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
    final projectStepId =
        context
            .read<WorkflowProcessDetailsBloc>()
            .stageDocsData
            ?.currentStep
            ?.id ??
        0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DocCommentsBloc()),
        BlocProvider(
          create: (context) => StageDocsBloc()
            ..add(
              LoadCurrentStepDocs(
                processId: processId,
                projectId: projectId,
                projectStepId: projectStepId,
              ),
            ),
        ),
      ],
      child: BlocBuilder<StageDocsBloc, StageDocsState>(
        buildWhen: (previous, current) => current is! StageDocsAdding,
        builder: (context, state) {
          final docCommentsBloc = context.read<DocCommentsBloc>();
          return switch (state) {
            // ── Loading ─────────────────────────
            StageDocsLoading() ||
            StageDocsInitial() => _buildShimmerLoading(context),

            // ── Loaded ────────────────────────────
            StageDocsLoaded(:final documentsData) => (() {
              final documents = documentsData.items ?? [];
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
                            SizedBox(width: 8.w),
                            _DocActionCardWidget(
                              icon: Assets.svgs.exporting.path,
                              onTap: () =>
                                  _showHtmlContent(context, document.document!),
                            ),
                            SizedBox(width: 4.w),
                            _DocActionCardWidget(
                              icon: Assets.svgs.eye.path,
                              onTap: () {
                                docCommentsBloc.add(
                                  LoadDocComments(documentId: document.id ?? 0),
                                );
                                PopUpHelper.showBottomSheet(
                                  header: allTranslations.text(
                                    LocaleKeys.view_comments,
                                  ),
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
                        SizedBox(height: 8.h),
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
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allTranslations.text(
                                      LocaleKeys.operation_name,
                                    ),
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          fontSize: FontSizes.f10,
                                          color: context.color.outlineVariant,
                                        ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    processName,
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(fontSize: FontSizes.f10),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<StageDocsBloc, StageDocsState>(
                          builder: (context, state) {
                            final bloc = context.read<StageDocsBloc>();
                            final documentId = document.id ?? 0;
                            final formKey = bloc.getFormKey(documentId);
                            final controller = bloc.getCommentController(
                              documentId,
                            );
                            final isAdding =
                                (state is StageDocsAdding) &&
                                bloc.addingDocumentId == documentId;

                            if (formKey == null ||
                                controller == null ||
                                documentId == 0) {
                              return const SizedBox.shrink();
                            }

                            return Form(
                              key: formKey,
                              child: CustomTextField(
                                verticalPadding: 0,
                                isReadOnly: isAdding,
                                color: isAdding ? context.color.outline : null,
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
            StageDocsEmpty() => EmptyContainer(
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
