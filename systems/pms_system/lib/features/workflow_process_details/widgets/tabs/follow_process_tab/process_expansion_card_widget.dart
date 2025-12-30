import 'package:pms_system/features/workflow_process_details/model/workflow_process_details_model.dart';

import '../../../../../core/utility/pms_exports.dart';

class ProcessExpansionCardWidget extends StatelessWidget {
  final List<WorkflowProcessGroupModel> processList;
  final int index;

  const ProcessExpansionCardWidget({
    super.key,
    required this.processList,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final processSteps = processList[index].steps;
    return CustomExpansionCard(
      title: processList[index].groupName ?? '',
      initialExpanded: index == 0,
      leadingWidget: _ProcessProgressWidget(
        progress: processList[index].progress ?? 0,
        // progress: 100,
      ),
      withMargin: false,
      child: Column(
        children: List.generate((processSteps ?? []).length, (idx) {
          final process = processSteps?[idx];
          return _ProcessStepRowWidget(
            title: process?.stepName ?? '',
            status: process?.status ?? 0,
          );
        }),
      ),
    );
  }
}

class _ProcessProgressWidget extends StatelessWidget {
  final double progress;

  const _ProcessProgressWidget({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: progress / 100,
          strokeWidth: 3,
          backgroundColor: context.color.tertiary.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(context.color.tertiary),
        ),
        Text(
          (progress % 1 == 0)
              ? '${progress.toInt()}%'
              : '${progress.toString()}%',
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: context.color.tertiary,
          ),
        ),
      ],
    );
  }
}

class _ProcessStepRowWidget extends StatelessWidget {
  final String title;
  final int status;

  const _ProcessStepRowWidget({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: context.color.outlineVariant.withValues(alpha: 0.3),
            size: 10,
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(title, style: context.textTheme.bodySmall)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor(status, context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              _statusName(status),
              style: context.textTheme.bodySmall?.copyWith(
                color: _statusColor(status, context),
                fontSize: FontSizes.f10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _statusName(int? status) {
  switch (status) {
    case 0:
      return allTranslations.text(LocaleKeys.not_completed);
    case 1:
      return allTranslations.text(LocaleKeys.completed);
    default:
      return allTranslations.text(LocaleKeys.in_progress);
  }
}

Color _statusColor(int? status, BuildContext context) {
  switch (status) {
    case 0:
      return context.color.outlineVariant;
    case 1:
      return context.color.tertiary;
    default:
      return context.color.secondary;
  }
}
