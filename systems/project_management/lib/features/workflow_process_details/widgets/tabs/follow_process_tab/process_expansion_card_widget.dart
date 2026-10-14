import 'package:project_management/core/utility/project_management_exports.dart';

/// A step group of the process: its progress and the status of each step.
class ProcessExpansionCardWidget extends StatelessWidget {
  final GroupStepsData group;
  final bool initiallyExpanded;

  const ProcessExpansionCardWidget({
    super.key,
    required this.group,
    this.initiallyExpanded = false,
  });

  /// `40%`, or `33.3%` for a fraction: the label sits inside a small circle,
  /// so long decimals such as `33.333333333333336` can't be shown.
  static String progressLabel(double progress) {
    final rounded = (progress * 10).round() / 10;
    return rounded % 1 == 0
        ? '${rounded.toInt()}%'
        : '${rounded.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: group.groupName ?? '',
      initialExpanded: initiallyExpanded,
      leadingWidget: _ProcessProgressWidget(progress: group.progress ?? 0),
      withMargin: false,
      child: Column(
        children: [
          for (final step in group.steps ?? const <WorkflowProcessStepModel>[])
            _ProcessStepRowWidget(
              title: step.stepName ?? '',
              status: step.status ?? '',
            ),
        ],
      ),
    );
  }
}

class _ProcessProgressWidget extends StatelessWidget {
  final double progress;

  const _ProcessProgressWidget({required this.progress});

  @override
  Widget build(BuildContext context) {
    final color = context.color.tertiary;

    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: (progress / 100).clamp(0.0, 1.0),
          strokeWidth: 3,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        Text(
          ProcessExpansionCardWidget.progressLabel(progress),
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ProcessStepRowWidget extends StatelessWidget {
  final String title;
  final String status;

  const _ProcessStepRowWidget({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    final (:name, :color) = _StepStatus.of(status, context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: context.color.outlineVariant.withValues(alpha: 0.3),
            size: 10,
          ),
          SizedBox(width: 6.w),
          Expanded(child: Text(title, style: context.textTheme.bodySmall)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              name,
              style: context.textTheme.bodySmall?.copyWith(
                color: color,
                fontSize: FontSizes.f10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

abstract final class _StepStatus {
  /// The label and color of a workflow step status. A step the API reports
  /// with any other status is still running.
  static ({String name, Color color}) of(String status, BuildContext context) {
    return switch (status) {
      'None' => (
        name: allTranslations.text(LocaleKeys.not_completed),
        color: context.color.outlineVariant,
      ),
      'Approved' || 'Completed' => (
        name: allTranslations.text(LocaleKeys.completed),
        color: context.color.tertiary,
      ),
      'Rejected' => (
        name: allTranslations.text(LocaleKeys.rejected),
        color: context.color.error,
      ),
      _ => (
        name: allTranslations.text(LocaleKeys.in_progress),
        color: context.color.secondary,
      ),
    };
  }
}
