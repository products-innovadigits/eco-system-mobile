import 'package:pms_system/core/utility/pms_exports.dart';

class RequestCardWidget extends StatelessWidget {
  final LatestRequestItem requestItem;

  const RequestCardWidget({super.key, required this.requestItem});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = requestItem.isCompletedWorkflow ?? false;
    return GestureDetector(
      onTap: () {
        CustomNavigator.push(
          Routes.WORKFLOW_PROCESS_DETAILS,
          arguments: WorkflowProcessDetailsArgs(
            processId: requestItem.process?.id ?? 0,
            projectId: requestItem.project?.id ?? 0,
            processName: requestItem.process?.title ?? '',
            projectName: requestItem.project?.name ?? '',
            stageName: 'stage name',
            projectManagerName: requestItem.project?.createdBy ?? '',
            projectBudget: requestItem.project?.budget?.toDouble() ?? 0.0,
            projectStartDate: requestItem.project?.startDate != null
                ? DateTime.parse(requestItem.project!.startDate!)
                : null,
            projectEndDate: requestItem.project?.endDate != null
                ? DateTime.parse(requestItem.project!.endDate!)
                : null,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border.all(color: context.color.outline),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.color.secondary.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '#${requestItem.id}',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.color.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    requestItem.project?.name ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall,
                  ),
                ),
                CustomInfoContainerWidget(
                  color: isCompleted
                      ? context.color.tertiary
                      : context.color.secondary,
                  title: isCompleted
                      ? allTranslations.text(LocaleKeys.completed)
                      : allTranslations.text(LocaleKeys.in_progress),
                  radius: 25,
                  fontSize: 10,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Images(
                  image: Assets.svgs.setting.path,
                  width: 12.w,
                  height: 12.w,
                  color: context.color.outlineVariant,
                ),
                SizedBox(width: 4.w),
                Text(
                  '${allTranslations.text(LocaleKeys.process)}: ',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.outlineVariant,
                    fontSize: 10,
                  ),
                ),
                Expanded(
                  child: Text(
                    requestItem.process?.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.color.secondary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Images(
                        image: Assets.svgs.user.path,
                        width: 12.w,
                        height: 12.w,
                        color: context.color.outlineVariant,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${allTranslations.text(LocaleKeys.by)}: ',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.color.outlineVariant,
                          fontSize: 10,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          requestItem.createdBy ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.secondary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Row(
                    children: [
                      Images(
                        image: Assets.svgs.calendar.path,
                        width: 12.w,
                        height: 12.w,
                        color: context.color.outlineVariant,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${allTranslations.text(LocaleKeys.added_date)}: ',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.color.outlineVariant,
                          fontSize: 10,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          requestItem.createdAt?.substring(0, 10) ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.secondary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
