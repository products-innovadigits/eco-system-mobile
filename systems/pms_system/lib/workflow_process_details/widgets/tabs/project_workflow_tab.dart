import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectWorkflowTab extends StatelessWidget {
  final List<ProjectStagesModel> stagesList;

  const ProjectWorkflowTab({super.key, required this.stagesList});

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      separatorPadding: 12,
      data: List.generate(
        stagesList.length,
        (index) => CustomExpansionCard(
          title: stagesList[index].title ?? '',
          initialExpanded: index == 0,
          leadingWidget: _StageCountWidget(
            count: stagesList[index].projectProcesses?.length ?? 0,
          ),
          withMargin: false,
          child: Column(
            children: List.generate(
              stagesList[index].projectProcesses?.length ?? 0,
              (idx) => _ProcessRowWidget(
                title: stagesList[index].projectProcesses?[idx].title ?? '',
                status: 'في تقدم',
                color: context.color.secondary,
              ),
            ),
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

class _ProcessRowWidget extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  const _ProcessRowWidget({
    required this.title,
    required this.status,
    required this.color,
  });

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
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Text(
                    status,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontSize: FontSizes.f10,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, color: color, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
