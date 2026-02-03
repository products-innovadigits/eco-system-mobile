import 'package:project_management/features/workflow_process_details/widgets/tabs/technical_log_tab/technical_log_tab_comments_section.dart';

import '../../../../../core/utility/pms_exports.dart';

class TechnicalLogTimelineCard extends StatelessWidget {
  final String processGroup;
  final String stageName;
  final String employee;
  final String time;
  final String commenter;
  final List<StepCommentModel> comments;
  final List<AttachmentModel> attachments;
  final String date;
  final String month;

  const TechnicalLogTimelineCard({
    super.key,
    required this.processGroup,
    required this.stageName,
    required this.employee,
    required this.time,
    required this.commenter,
    required this.comments,
    required this.attachments,
    required this.date,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          _TimelineIndicator(date: date, month: month),
          SizedBox(width: 8.w),
          // Main content card
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
                  /// Process group and stage info
                  Row(
                    children: [
                      Expanded(
                        child: _InfoSection(
                          label: allTranslations.text(LocaleKeys.step_name),
                          value: stageName,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _InfoSection(
                          label: allTranslations.text(
                            LocaleKeys.process_group_label,
                          ),
                          value: processGroup,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  /// Employee info
                  _InfoSection(
                    label: allTranslations.text(LocaleKeys.employee_label),
                    value: employee,
                  ),
                  SizedBox(height: 8.h),

                  /// Divider
                  Container(height: 1, color: context.color.outline),
                  SizedBox(height: 12.h),

                  /// Comments section
                  TechnicalLogTabCommentsSection(comments: comments),
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
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  final String date;
  final String month;

  const _TimelineIndicator({required this.date, required this.month});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month label
        Text(
          month,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.color.primary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        // Date badge
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: context.color.secondary,
            borderRadius: BorderRadius.circular(1000),
          ),
          child: Center(
            child: Text(
              date,
              style: context.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // Timeline line
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
