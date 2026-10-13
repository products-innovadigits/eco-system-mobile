import 'package:project_management/core/utility/project_management_exports.dart';

class ProcessHeaderCard extends StatelessWidget {
  final StageDocData data;

  const ProcessHeaderCard({super.key, required this.data});

  /// The `yyyy-MM-dd` part of an API date-time, or the value as is when it's
  /// shorter than that.
  static String _datePart(String? dateTime) {
    if (dateTime == null) return '';
    return dateTime.length > 10 ? dateTime.substring(0, 10) : dateTime;
  }

  @override
  Widget build(BuildContext context) {
    final detailStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: FontSizes.f10,
      color: context.color.secondary,
    );
    final dateStyle = context.textTheme.labelSmall?.copyWith(
      color: context.color.outlineVariant,
      fontSize: FontSizes.f10,
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border(bottom: BorderSide(color: context.color.outline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: context.color.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.color.outline),
            ),
            child: Images(
              image: Assets.svgs.moneys.path,
              width: 24.w,
              height: 24.w,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.processTitle ?? '',
                    style: context.textTheme.displaySmall?.copyWith(
                      fontSize: FontSizes.f14,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${allTranslations.text(LocaleKeys.stage_name)} : ${data.processStageTitle ?? ''}',
                    style: detailStyle,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${allTranslations.text(LocaleKeys.current_step)} : ${data.currentStep?.text ?? ''}',
                    style: detailStyle,
                  ),
                  Text.rich(
                    TextSpan(
                      text:
                          '${allTranslations.text(LocaleKeys.start_time)} ${_datePart(data.projectStartDate)}',
                      children: [
                        const TextSpan(text: '  |  '),
                        TextSpan(
                          text:
                              '${allTranslations.text(LocaleKeys.end_time)}: ${_datePart(data.projectEndDate)}',
                        ),
                      ],
                    ),
                    style: dateStyle,
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        '${allTranslations.text(LocaleKeys.project_fund)}: ${data.projectBudget ?? ''}',
                      ),
                      _InfoChip(
                        '${allTranslations.text(LocaleKeys.project_manager)}:  ${data.projectManager ?? ''}',
                      ),
                    ],
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

class _InfoChip extends StatelessWidget {
  final String text;

  const _InfoChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.color.tertiaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.color.tertiary,
          fontSize: FontSizes.f10,
        ),
      ),
    );
  }
}
