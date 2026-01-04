import 'package:pms_system/core/utility/pms_exports.dart';

class CustomBarChart extends StatelessWidget {
  final List<ProjectCategoriesProgressModel> data;
  final double? chartHeight;
  final bool? showAll;
  final bool? showPercentageAxis;

  const CustomBarChart({
    super.key,
    required this.data,
    this.chartHeight,
    this.showAll,
    this.showPercentageAxis = true,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = showAll == true
        ? data.length
        : data.length > 4
        ? 4
        : data.length;

    Widget chartContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        showAll == true
            ? ConstrainedBox(
                constraints: BoxConstraints(maxHeight: chartHeight ?? 260.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: itemCount,
                  separatorBuilder: (_, _) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    return _buildBarItem(context, data[index], index);
                  },
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                separatorBuilder: (_, _) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  return _buildBarItem(context, data[index], index);
                },
              ),
        if (showPercentageAxis == true) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Container()),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "0%",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.outlineVariant,
                      ),
                    ),
                    Text(
                      "20%",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.outlineVariant,
                      ),
                    ),
                    Text(
                      "40%",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.outlineVariant,
                      ),
                    ),
                    Text(
                      "60%",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.outlineVariant,
                      ),
                    ),
                    Text(
                      "80%",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.outlineVariant,
                      ),
                    ),
                    Text(
                      "100%",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.outlineVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );

    return chartContent;
  }

  Widget _buildBarItem(
    BuildContext context,
    ProjectCategoriesProgressModel item,
    int index,
  ) {
    final progress = (item.progress ?? 0).clamp(0, 100);
    final Color color = LightColor
        .projectCategoryColors[index % LightColor.projectCategoryColors.length];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title (fixed width column)
        Expanded(
          child: Text(
            item.name ?? "",
            style: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
            ),
          ),
        ),
        // Progress container
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Background
              Container(
                height: 22,
                margin: const EdgeInsets.symmetric(horizontal: 9),
                padding: const EdgeInsetsDirectional.only(end: 6),
                decoration: BoxDecoration(
                  color: context.color.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: AlignmentDirectional.centerEnd,
                child: progress.toInt() < 82
                    ? Text(
                        "$progress%",
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : const SizedBox(),
              ),
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: progress / 100,
                child: Container(
                  height: 22,
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  margin: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: AlignmentDirectional.centerEnd,
                  child: progress.toInt() >= 82
                      ? Text(
                          "$progress%",
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.color.onPrimary,
                            fontSize: 10,
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
