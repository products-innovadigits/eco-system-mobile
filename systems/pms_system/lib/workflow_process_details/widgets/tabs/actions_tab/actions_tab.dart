import 'dart:io';

import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/bloc/actions_tab_bloc.dart';

class ActionsTab extends StatelessWidget {
  final int processId;
  final int projectId;
  final int projectStepId;

  const ActionsTab({
    super.key,
    required this.processId,
    required this.projectId,
    required this.projectStepId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionsTabBloc(),
      child: _ActionsTabContent(
        processId: processId,
        projectId: projectId,
        projectStepId: projectStepId,
      ),
    );
  }
}

class _ActionsTabContent extends StatelessWidget {
  final int processId;
  final int projectId;
  final int projectStepId;

  const _ActionsTabContent({
    required this.processId,
    required this.projectId,
    required this.projectStepId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionsTabBloc, AppState>(
      listener: (context, state) {
        // When compliance is successful, refresh the StageDocsBloc to update nextStep
        if (state is Done && state.data == null) {
          // This is a compliance success
          final stageDocsBloc = context.read<StageDocsBloc>();
          stageDocsBloc.add(
            Click(arguments: {'projectId': projectId, 'processId': processId}),
          );
        }
      },
      child: BlocBuilder<ActionsTabBloc, AppState>(
        builder: (context, state) {
          final bloc = context.read<ActionsTabBloc>();

          return Form(
            key: bloc.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Internal Comments Section
                _InternalCommentsSection(
                  controller: bloc.commentController,
                  validation: NotEmptyValidator.notEmptyValidator,
                ),

                // File Upload Section
                _FileUploadSection(
                  selectedFile: bloc.selectedFile,
                  fileName: bloc.fileName,
                  fileSize: bloc.fileSize,
                  onPickFile: () => bloc.add(PickFile()),
                  onRemoveFile: () => bloc.add(RemoveFile()),
                ),

                SizedBox(height: 16.h),

                // Action Buttons Section
                BlocBuilder<StageDocsBloc, AppState>(
                  builder: (ctx, stageState) {
                    final nextStep = ctx
                        .read<StageDocsBloc>()
                        .stageDocsData
                        ?.nextStep;
                    final nextStepText =
                        (nextStep != null && nextStep.isNotEmpty)
                        ? (nextStep[0].text ?? '')
                        : '';
                    return _ActionButtonsSection(
                      onSave: () => _onSave(context),
                      onCompliance: () => _onCompliance(context),
                      isLoading: stageState is Loading,
                      nextStepText: nextStepText,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSave(BuildContext context) {
    final bloc = context.read<ActionsTabBloc>();
    bloc.add(
      Click(
        arguments: {
          'projectId': projectId,
          'projectStepId': projectStepId,
          'processId': processId,
        },
      ),
    );
  }

  void _onCompliance(BuildContext context) {
    // Read the nextStepId from StageDocsBloc to get the most current value
    final stageDocsBloc = context.read<StageDocsBloc>();
    final nextStep = stageDocsBloc.stageDocsData?.nextStep;
    final nextStepId = (nextStep != null && nextStep.isNotEmpty)
        ? nextStep[0].id
        : 0;

    final bloc = context.read<ActionsTabBloc>();
    bloc.add(
      ComplianceClick(
        arguments: {
          'projectId': projectId,
          'processId': processId,
          'nextStepId': nextStepId,
        },
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
              color: context.color.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.color.primary.withOpacity(0.3),
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
                            color: context.color.primary.withOpacity(0.7),
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
  final bool isLoading;
  final String nextStepText;

  const _ActionButtonsSection({
    required this.onSave,
    required this.onCompliance,
    required this.isLoading,
    required this.nextStepText,
  });

  @override
  Widget build(BuildContext context) {
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
          loading: isLoading,
          onPressed: isLoading ? null : onSave,
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
              loading: isLoading,
              onPressed: isLoading ? null : onCompliance,
            ),
          ),
        ],
      ],
    );
  }
}
