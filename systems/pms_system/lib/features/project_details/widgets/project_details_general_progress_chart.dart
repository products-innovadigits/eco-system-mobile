import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectDetailsGeneralProgressChart extends StatelessWidget {
  const ProjectDetailsGeneralProgressChart({super.key, required this.data});

  final List<ProjectCategoriesProgressModel> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, _) => SizedBox(height: 18.h),
              itemBuilder: (context, index) {
                return _buildBarItem(context, data[index]);
              },
            ),
          ),
          SizedBox(height: 16.h),
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
      ),
    );
  }

  Widget _buildBarItem(
    BuildContext context,
    ProjectCategoriesProgressModel item,
  ) {
    final progress = (item.progress ?? 0).clamp(0, 100);

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
                          color: item.color,
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
                    color: item.color ?? context.color.primary,
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
