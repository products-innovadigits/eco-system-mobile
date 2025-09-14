import 'package:pms_system/shared/pms_exports.dart';

class ProjectCategoriesChart extends StatelessWidget {
  const ProjectCategoriesChart({
    super.key,
    this.withIntervals = true,
    required this.data,
    this.isPmsHome = false,
    this.textColor,
    this.barColor,
  });

  final List<ProjectCategoriesProgressModel> data;
  final Color? textColor, barColor;
  final bool withIntervals;
  final bool isPmsHome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: isPmsHome
                  ? data.length
                  : data.length > 4
                  ? 4
                  : data.length,
              separatorBuilder: (_, _) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final item = data[index];
                final progress = (item.progress ?? 0).clamp(0, 100);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title (fixed width column)
                    Expanded(
                      child: Text(
                        item.name ?? "",
                        style: context.textTheme.bodySmall?.copyWith(
                          color: textColor ?? context.color.outlineVariant,
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
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(
                                          fontSize: 10,
                                          color:
                                              barColor ??
                                              item.color ??
                                              LightColor
                                                  .projectCategoryColors[0],
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
                                color:
                                    barColor ??
                                    item.color ??
                                    LightColor.projectCategoryColors[0],
                                borderRadius: BorderRadius.circular(2),
                              ),
                              alignment: AlignmentDirectional.centerEnd,
                              child: progress.toInt() >= 82
                                  ? Text(
                                      "$progress%",
                                      style: context.textTheme.labelSmall
                                          ?.copyWith(
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
              },
            ),
          ),
          if (withIntervals) ...[
            const SizedBox(height: 16),
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
      ),
    );
  }
}
