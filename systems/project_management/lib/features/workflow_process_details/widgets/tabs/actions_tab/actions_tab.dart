import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

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
      create: (context) => ActionsTabBloc(repo: projectManagementSl()),
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
    final status = context
        .read<ProcessDetailsBloc>()
        .stageDocsData
        ?.workFlowStatus;

    return BlocListener<ActionsTabBloc, ActionsTabState>(
      // Moving to the next step changes the current and next steps, so the
      // screen reloads them.
      listenWhen: (_, current) => current is MoveToNextStepSuccess,
      listener: (context, _) => context.read<ProcessDetailsBloc>().add(
        LoadGroupSteps(projectId: projectId, processId: processId),
      ),
      child: switch (status) {
        'InProgress' => _ActionsForm(
          processId: processId,
          projectId: projectId,
        ),
        'Completed' => EmptyContainer(
          txt: allTranslations.text(LocaleKeys.process_done),
        ),
        _ => EmptyContainer(
          txt: allTranslations.text(LocaleKeys.start_process_first),
        ),
      },
    );
  }
}

class _ActionsForm extends StatefulWidget {
  final int processId;
  final int projectId;

  const _ActionsForm({required this.processId, required this.projectId});

  @override
  State<_ActionsForm> createState() => _ActionsFormState();
}

class _ActionsFormState extends State<_ActionsForm> {
  final _formKey = GlobalKey<FormState>();

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final projectStepId = context
        .read<ProcessDetailsBloc>()
        .stageDocsData
        ?.currentStep
        ?.id;
    if (projectStepId == null) {
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
      return;
    }

    context.read<ActionsTabBloc>().add(
      SaveComment(
        projectId: widget.projectId,
        projectStepId: projectStepId,
        processId: widget.processId,
      ),
    );
  }

  /// Moves to the next step, or finishes the process when [isLastStep]: the
  /// same endpoint is called with no next step then.
  void _onMove({required bool isLastStep}) {
    final nextStepId = isLastStep
        ? null
        : context
                  .read<ProcessDetailsBloc>()
                  .stageDocsData
                  ?.nextStep
                  ?.firstOrNull
                  ?.id ??
              0;

    context.read<ActionsTabBloc>().add(
      MoveToNextStep(
        projectId: widget.projectId,
        processId: widget.processId,
        nextStepId: nextStepId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ActionsTabBloc>();

    // Scrollable: the fields grow with their validation errors and the
    // keyboard eats the rest, so a fixed column overflows the tab.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // The controller holds the text, so no bloc state rebuilds it.
            _InternalCommentsSection(
              controller: bloc.commentTEC,
              validation: NotEmptyValidator.notEmptyValidator,
            ),
            BlocBuilder<ActionsTabBloc, ActionsTabState>(
              // Only the attachment itself changes this section. A
              // successful save clears the attachment, so it repaints on
              // that too.
              buildWhen: (previous, current) =>
                  current is ActionsTabFileSelected ||
                  current is ActionsTabFileRemoved ||
                  current is SaveCommentSuccess,
              builder: (context, state) {
                final picked = state is ActionsTabFileSelected ? state : null;
                return _FileUploadSection(
                  hasFile: picked != null,
                  fileName: picked?.fileName,
                  fileSize: picked?.fileSize,
                  onPickFile: () => bloc.add(const PickFile()),
                  onRemoveFile: () => bloc.add(const RemoveFile()),
                );
              },
            ),
            SizedBox(height: 16.h),
            _SaveButton(onSave: _onSave),
            _NextStepButton(
              onCompliance: () => _onMove(isLastStep: false),
              onFinishProcess: () => _onMove(isLastStep: true),
            ),
          ],
        ),
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
    return CustomTextField(
      controller: controller,
      label: allTranslations.text(LocaleKeys.internal_comments),
      hint: allTranslations.text(LocaleKeys.enter_internal_comments),
      hintStyle: context.textTheme.bodySmall,
      maxLines: 3,
      minLines: 1,
      validation: validation,
    );
  }
}

class _FileUploadSection extends StatelessWidget {
  final bool hasFile;
  final String? fileName;
  final String? fileSize;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const _FileUploadSection({
    required this.hasFile,
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
          hint: hasFile
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
        if (hasFile) ...[
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

/// Whether a save or a move is in flight; the buttons only change with it.
bool _isBusy(ActionsTabState state) =>
    state is SaveCommentLoading || state is MoveToNextStepLoading;

class _SaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const _SaveButton({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionsTabBloc, ActionsTabState>(
      buildWhen: (previous, current) => _isBusy(previous) != _isBusy(current),
      builder: (context, state) {
        final isLoading = state is SaveCommentLoading;
        final isOtherLoading = state is MoveToNextStepLoading;

        return CustomBtn(
          text: allTranslations.text(LocaleKeys.save),
          color: Colors.transparent,
          textColor: context.color.primary,
          borderColor: context.color.primary,
          loadingColor: context.color.primary,
          height: 34,
          fontSize: 12,
          borderRadius: 8,
          loading: isLoading,
          onPressed: (isLoading || isOtherLoading) ? null : onSave,
        );
      },
    );
  }
}

class _NextStepButton extends StatelessWidget {
  final VoidCallback onCompliance;
  final VoidCallback onFinishProcess;

  const _NextStepButton({
    required this.onCompliance,
    required this.onFinishProcess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionsTabBloc, ActionsTabState>(
      buildWhen: (previous, current) => _isBusy(previous) != _isBusy(current),
      builder: (context, actionsTabState) {
        return BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
          // The next step only changes when a load finishes, which changes
          // the state type; tab switches re-emit the same type.
          buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
          builder: (context, processDetailsState) {
            final workflowBloc = context.read<ProcessDetailsBloc>();
            final stageDocsData = workflowBloc.stageDocsData;
            final currentStep = stageDocsData?.currentStep;
            final nextStep = stageDocsData?.nextStep;
            final nextStepText = (nextStep != null && nextStep.isNotEmpty)
                ? (nextStep[0].text ?? '')
                : '';

            // The last step of the workflow has nothing to move to, so the
            // only remaining action is finishing the process.
            final bool isFinishProcess =
                currentStep?.category == 'Step' &&
                currentStep?.isLastStep == true;

            if (!isFinishProcess && nextStepText.isEmpty) {
              return const SizedBox.shrink();
            }

            final isLoading =
                actionsTabState is MoveToNextStepLoading ||
                processDetailsState is GroupStepsLoading;
            final isOtherLoading = actionsTabState is SaveCommentLoading;

            return Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: SizedBox(
                width: double.infinity,
                child: CustomBtn(
                  text: isFinishProcess
                      ? allTranslations.text(LocaleKeys.finish_process)
                      : nextStepText,
                  color: context.color.primary,
                  textColor: context.color.onPrimary,
                  height: 34,
                  fontSize: 12,
                  borderRadius: 8,
                  loading: isLoading,
                  onPressed: (isLoading || isOtherLoading)
                      ? null
                      : (isFinishProcess ? onFinishProcess : onCompliance),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
