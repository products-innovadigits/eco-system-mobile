import 'dart:io';

import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/workflow_process_details/bloc/actions_tab/actions_tab_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/actions_tab/actions_tab_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/actions_tab/actions_tab_state.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_events.dart';
import 'package:pms_system/features/workflow_process_details/bloc/process_details/process_details_state.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_bloc.dart';
import 'package:pms_system/features/workflow_process_details/bloc/stage_docs/stage_docs_events.dart';

class ActionsTab extends StatelessWidget {
  final int processId;
  final int projectId;

  const ActionsTab({
    super.key,
    required this.processId,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionsTabBloc(),
      child: _ActionsTabContent(processId: processId, projectId: projectId),
    );
  }
}

class _ActionsTabContent extends StatelessWidget {
  final int processId;
  final int projectId;

  const _ActionsTabContent({required this.processId, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionsTabBloc, ActionsTabState>(
      listener: (context, state) {
        // When compliance is successful, refresh the WorkflowProcessDetailsBloc to update nextStep
        if (state is ActionsTabSuccess) {
          final actionsTabBloc = context.read<ActionsTabBloc>();
          // Only trigger reload if this was a compliance action, not a save action
          if (actionsTabBloc.isComplianceCompleted) {
            final workFlowProcessDetailsBloc = context
                .read<ProcessDetailsBloc>();
            workFlowProcessDetailsBloc.add(
              LoadProcessDetails(projectId: projectId, processId: processId),
            );
            context.read<StageDocsBloc>().add(
              CreateCurrentStepDocs(
                processId: processId,
                projectId: projectId,
                projectStepId:
                    workFlowProcessDetailsBloc.stageDocsData?.currentStep?.id ??
                    0,
              ),
            );
            // Reset the flag after triggering reload
            actionsTabBloc.resetComplianceFlag();
          }
        }
      },
      child: Form(
        key: context.read<ActionsTabBloc>().formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Internal Comments Section
            BlocBuilder<ActionsTabBloc, ActionsTabState>(
              builder: (context, state) {
                final bloc = context.read<ActionsTabBloc>();
                return _InternalCommentsSection(
                  controller: bloc.commentController,
                  validation: NotEmptyValidator.notEmptyValidator,
                );
              },
            ),

            // File Upload Section
            BlocBuilder<ActionsTabBloc, ActionsTabState>(
              builder: (context, state) {
                final bloc = context.read<ActionsTabBloc>();
                return _FileUploadSection(
                  selectedFile: bloc.selectedFile,
                  fileName: bloc.fileName,
                  fileSize: bloc.fileSize,
                  onPickFile: () => bloc.add(const PickFile()),
                  onRemoveFile: () => bloc.add(const RemoveFile()),
                );
              },
            ),

            SizedBox(height: 16.h),

            // Action Buttons Section
            BlocBuilder<ActionsTabBloc, ActionsTabState>(
              builder: (context, actionsTabState) {
                return BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
                  builder: (context, workFlowProcessDetailsState) {
                    final workflowBloc = context.read<ProcessDetailsBloc>();
                    final nextStep = workflowBloc.stageDocsData?.nextStep;
                    final nextStepText =
                        (nextStep != null && nextStep.isNotEmpty)
                        ? (nextStep[0].text ?? '')
                        : '';

                    final actionsTabBloc = context.read<ActionsTabBloc>();
                    // Save button loading: from ActionsTabBloc when SaveComment event is processing (loading but not compliance)
                    final isSaveLoading =
                        actionsTabState is ActionsTabLoading &&
                        !actionsTabBloc.isComplianceActionLoading;
                    // Compliance button loading: from ActionsTabBloc when MoveToNextStep is processing OR from WorkflowProcessDetailsBloc when reloading after compliance
                    final isComplianceLoading =
                        (actionsTabState is ActionsTabLoading &&
                            actionsTabBloc.isComplianceActionLoading) ||
                        (workFlowProcessDetailsState is ProcessDetailsLoading);

                    return _ActionButtonsSection(
                      onSave: () => _onSave(context),
                      onCompliance: () => _onCompliance(context),
                      isSaveLoading: isSaveLoading,
                      isComplianceLoading: isComplianceLoading,
                      nextStepText: nextStepText,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    final workflowBloc = context.read<ProcessDetailsBloc>();
    final projectStepId = workflowBloc.stageDocsData?.currentStep?.id;

    // Validate that projectStepId is not null
    if (projectStepId == null) {
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
      return;
    }

    final bloc = context.read<ActionsTabBloc>();
    bloc.add(
      SaveComment(
        projectId: projectId,
        projectStepId: projectStepId,
        processId: processId,
      ),
    );
  }

  void _onCompliance(BuildContext context) {
    // Read the nextStepId from StageDocsBloc to get the most current value
    final workflowProcessDetailsBloc = context.read<ProcessDetailsBloc>();
    final nextStep = workflowProcessDetailsBloc.stageDocsData?.nextStep;
    final nextStepId = (nextStep != null && nextStep.isNotEmpty)
        ? nextStep[0].id
        : 0;

    final bloc = context.read<ActionsTabBloc>();
    bloc.add(
      MoveToNextStep(
        projectId: projectId,
        processId: processId,
        nextStepId: nextStepId ?? 0,
      ),
    );
  }
}

class _InternalCommentsSection extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validation;

  const _InternalCommentsSection({required this.controller, this.validation});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: controller,
          label: allTranslations.text(LocaleKeys.internal_comments),
          hint: allTranslations.text(LocaleKeys.enter_internal_comments),
          hintStyle: context.textTheme.bodySmall,
          maxLines: 3,
          minLines: 1,
          validation: validation,
        ),
      ],
    );
  }
}

class _FileUploadSection extends StatelessWidget {
  final File? selectedFile;
  final String? fileName;
  final String? fileSize;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const _FileUploadSection({
    required this.selectedFile,
    required this.fileName,
    required this.fileSize,
    required this.onPickFile,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: allTranslations.text(LocaleKeys.upload_file),
          hint: selectedFile != null
              ? fileName
              : allTranslations.text(LocaleKeys.upload_additional_file),
          hintStyle: context.textTheme.bodySmall,
          prefixWidget: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12, end: 4),
            child: Images(image: Assets.svgs.upload.path),
          ),
          isReadOnly: true,
          onTap: onPickFile,
        ),

        // Show selected file details
        if (selectedFile != null) ...[
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: context.color.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.color.primary.withValues(alpha: .3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file, color: context.color.primary, size: 20),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName ?? '',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.color.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (fileSize != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          fileSize!,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.primary.withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRemoveFile,
                  icon: Icon(
                    Icons.close,
                    color: context.color.primary,
                    size: 20,
                  ),
                  constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ActionButtonsSection extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCompliance;
  final bool isSaveLoading;
  final bool isComplianceLoading;
  final String nextStepText;

  const _ActionButtonsSection({
    required this.onSave,
    required this.onCompliance,
    required this.isSaveLoading,
    required this.isComplianceLoading,
    required this.nextStepText,
  });

  @override
  Widget build(BuildContext context) {
    // Disable both buttons if either is loading
    final isAnyLoading = isSaveLoading || isComplianceLoading;

    return Column(
      children: [
        // Save Button (Outlined)
        CustomBtn(
          text: allTranslations.text(LocaleKeys.save),
          color: Colors.transparent,
          textColor: context.color.primary,
          borderColor: context.color.primary,
          loadingColor: context.color.primary,
          height: 34,
          fontSize: 12,
          borderRadius: 8,
          loading: isSaveLoading,
          onPressed: isAnyLoading ? null : onSave,
        ),

        // Only show Next Step button if there's a next step available
        if (nextStepText.isNotEmpty) ...[
          SizedBox(height: 16.h),

          // Primary Action Button
          SizedBox(
            width: double.infinity,
            child: CustomBtn(
              text: nextStepText,
              color: context.color.primary,
              textColor: context.color.onPrimary,
              height: 34,
              fontSize: 12,
              borderRadius: 8,
              loading: isComplianceLoading,
              onPressed: isAnyLoading ? null : onCompliance,
            ),
          ),
        ],
      ],
    );
  }
}
