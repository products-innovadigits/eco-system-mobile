import 'package:pms_system/workflow_process_details/model/workflow_process_details_model.dart';

import '../../../../shared/pms_exports.dart';

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
            status: (process?.status == 0 ? false : true)
                ? allTranslations.text(LocaleKeys.completed)
                : allTranslations.text(LocaleKeys.not_completed),
            isCompleted: process?.status == 0 ? false : true,
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
          '$progress%',
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
  final String status;
  final bool isCompleted;

  const _ProcessStepRowWidget({
    required this.title,
    required this.status,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCompleted
        ? context.color.secondary
        : context.color.outlineVariant;
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
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              status,
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
