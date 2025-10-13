import 'package:pms_system/shared/pms_exports.dart';

class ProjectOutputsBottomSheet extends StatelessWidget {
  final List<MobileOutputsSummaryModel> outputsSummary;

  const ProjectOutputsBottomSheet({super.key, required this.outputsSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(title: allTranslations.text(LocaleKeys.outputs)),
        const SizedBox(height: 24),
        ListAnimator(
          data: outputsSummary
              .map(
                (output) => output.key != 'total'
                    ? _OutputCardWidget(output: output)
                    : const SizedBox.shrink(),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _OutputCardWidget extends StatelessWidget {
  final MobileOutputsSummaryModel output;

  const _OutputCardWidget({required this.output});

  @override
  Widget build(BuildContext context) {
    final color = Color(
      int.parse((output.background ?? '#000000').replaceFirst('#', '0xff')),
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      margin: EdgeInsetsDirectional.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  output.label ?? '',
                  style: context.textTheme.labelMedium?.copyWith(color: color),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(output.value ?? 0)} ${allTranslations.text(LocaleKeys.outputs)}',
                  style: context.textTheme.labelSmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
          if ((output.titles ?? []).isNotEmpty) ...[
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 8.h),
              child: Divider(color: color.withValues(alpha: 0.1)),
            ),
            ListAnimator(
              data: (output.titles ?? [])
                  .map(
                    (output) => Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: color.withValues(alpha: 0.1),
                          ),
                          const SizedBox(width: 4),
                          Text(output, style: context.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
