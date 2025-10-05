import '../../../../shared/pms_exports.dart';

class StageExpansionCardWidget extends StatelessWidget {
  final List<ProjectStagesModel> stagesList;
  final int index;

  const StageExpansionCardWidget({
    super.key,
    required this.stagesList,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final stage = stagesList[index];
    return CustomExpansionCard(
      title: stage.title ?? '',
      initialExpanded: index == 0,
      leadingWidget: _StageCountWidget(
        count: stage.projectProcesses?.length ?? 0,
      ),
      withMargin: false,
      child: Column(
        children: List.generate(
          stage.projectProcesses?.length ?? 0,
          (idx) => _StageProcessCardWidget(
            title: stage.projectProcesses?[idx].title ?? '',
            status: 'في تقدم',
            color: context.color.secondary,
          ),
        ),
      ),
    );
  }
}

class _StageCountWidget extends StatelessWidget {
  final int count;

  const _StageCountWidget({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.color.primary,
      ),
      child: Text(
        '$count',
        style: context.textTheme.labelSmall?.copyWith(
          color: context.color.onPrimary,
        ),
      ),
    );
  }
}

class _StageProcessCardWidget extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  const _StageProcessCardWidget({
    required this.title,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CustomNavigator.push(
          Routes.WORKFLOW_PROCESS_DETAILS,
          arguments: 21,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.circle, color: color, size: 10),
            const SizedBox(width: 6),
            Expanded(child: Text(title, style: context.textTheme.bodySmall)),
            Icon(Icons.arrow_forward, color: color, size: 16),
            // InkWell(
            //   onTap: () {
            //     CustomNavigator.push(
            //       Routes.WORKFLOW_PROCESS_DETAILS,
            //       arguments: 21,
            //     );
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //     decoration: BoxDecoration(
            //       color: color.withValues(alpha: 0.1),
            //       borderRadius: BorderRadius.circular(25),
            //     ),
            //     child: Row(
            //       children: [
            //         Text(
            //           status,
            //           style: context.textTheme.bodySmall?.copyWith(
            //             color: color,
            //             fontSize: FontSizes.f10,
            //           ),
            //         ),
            //         SizedBox(width: 6),
            //         Icon(Icons.arrow_forward, color: color, size: 12),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
