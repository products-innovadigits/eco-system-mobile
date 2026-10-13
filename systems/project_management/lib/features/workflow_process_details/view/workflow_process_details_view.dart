import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class WorkflowProcessDetailsView extends StatelessWidget {
  const WorkflowProcessDetailsView({
    super.key,
    required this.processId,
    required this.projectId,
    required this.processName,
  });

  final int processId;
  final int projectId;
  final String processName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProcessDetailsBloc(repo: projectManagementSl())
            ..add(LoadGroupSteps(processId: processId, projectId: projectId)),
      child: Scaffold(
        appBar: CustomAppBar(
          title: processName,
          withBottomBorder: false,
          action: _WorkflowStatusAction(
            processId: processId,
            projectId: projectId,
          ),
        ),
        body: SafeArea(
          child: ProcessDetailsBody(projectId: projectId, processId: processId),
        ),
      ),
    );
  }
}

/// The workflow status in the app bar. While the process hasn't started it
/// is the button that starts it.
class _WorkflowStatusAction extends StatelessWidget {
  final int processId;
  final int projectId;

  const _WorkflowStatusAction({
    required this.processId,
    required this.projectId,
  });

  void _confirmStart(BuildContext context) {
    final bloc = context.read<ProcessDetailsBloc>();
    YesNoDialogHelper.showStartProcessConfirmationDialog(
      context: context,
      onStartPressed: () =>
          bloc.add(StartProcess(processId: processId, projectId: projectId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The status only changes when a load finishes, which always changes the
    // state type; tab switches re-emit the same type and are skipped.
    return BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final status = context
            .read<ProcessDetailsBloc>()
            .stageDocsData
            ?.workFlowStatus;
        final isScreenShown =
            state is GroupStepsLoaded ||
            state is GroupStepsEmpty ||
            state is GroupStepsReloading ||
            state is ProcessStarting;
        if (status == null || !isScreenShown) return const SizedBox.shrink();

        final isStart = status == 'NotStarted';
        final color = _statusColor(status);

        return InkWell(
          onTap: isStart && state is! ProcessStarting
              ? () => _confirmStart(context)
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isStart ? color : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isStart ? 8 : 25),
              border: Border.all(
                color: isStart ? context.color.primary : Colors.transparent,
              ),
            ),
            child: Text(
              _statusName(status),
              style: context.textTheme.bodySmall?.copyWith(
                color: isStart ? context.color.primary : color,
                fontSize: FontSizes.f10,
              ),
            ),
          ),
        );
      },
    );
  }

  static Color _statusColor(String status) => switch (status) {
    'NotStarted' => Colors.transparent,
    'InProgress' => LightColor.secondary,
    _ => LightColor.tertiary,
  };

  static String _statusName(String status) => switch (status) {
    'NotStarted' => allTranslations.text(LocaleKeys.start_process),
    'InProgress' => allTranslations.text(LocaleKeys.in_progress),
    _ => allTranslations.text(LocaleKeys.done),
  };
}
