import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/technical_log_tab/technical_log_tab_comments_section.dart';

class TechnicalLogTimelineCard extends StatelessWidget {
  final HistoryItemModel item;

  const TechnicalLogTimelineCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // FormattersHelper fills in made-up values for a missing date, so a step
    // without a change time shows an empty badge instead.
    final changeTime = item.lastChangeTime;
    final day = changeTime == null
        ? ''
        : FormattersHelper.formatDate(changeTime, isDate: true);
    final month = changeTime == null
        ? ''
        : FormattersHelper.formatDate(changeTime, isMonth: true);

    // IntrinsicHeight stretches the timeline line down to the card's bottom.
    // The list builds items lazily, so only visible cards pay for it.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineIndicator(day: day, month: month),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.color.surfaceContainer,
                border: Border.all(color: context.color.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _InfoSection(
                          label: allTranslations.text(LocaleKeys.step_name),
                          value: item.name ?? '',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _InfoSection(
                          label: allTranslations.text(
                            LocaleKeys.process_group_label,
                          ),
                          value: item.stepGroup?.groupName ?? '',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _InfoSection(
                    label: allTranslations.text(LocaleKeys.employee_label),
                    value: item.responsibleUser?.fullName ?? '',
                  ),
                  SizedBox(height: 8.h),
                  Container(height: 1, color: context.color.outline),
                  SizedBox(height: 12.h),
                  TechnicalLogTabCommentsSection(
                    comments: item.stepComments ?? const [],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String label;
  final String value;

  const _InfoSection({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: context.color.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(75),
          ),
          child: Images(image: Assets.svgs.calendar.path, color: Colors.black),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: FontSizes.f10,
                  color: context.color.outlineVariant,
                ),
              ),
              Text(
                value,
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: FontSizes.f10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  final String day;
  final String month;

  const _TimelineIndicator({required this.day, required this.month});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          month,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.color.primary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: context.color.secondary,
            borderRadius: BorderRadius.circular(1000),
          ),
          child: Center(
            child: Text(
              day,
              style: context.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // Runs down to the bottom of the card next to it.
        Expanded(
          child: Container(
            width: 4.w,
            decoration: BoxDecoration(
              color: context.color.secondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
