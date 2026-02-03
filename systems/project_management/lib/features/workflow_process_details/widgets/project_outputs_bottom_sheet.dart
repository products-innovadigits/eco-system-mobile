import 'package:project_management/core/utility/pms_exports.dart';

class ProjectOutputsBottomSheet extends StatelessWidget {
  const ProjectOutputsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(title: allTranslations.text(LocaleKeys.outputs)),
        SizedBox(height: 24.h),
        ListAnimator(
          data: [
            _OutputCardWidget(
              outputStatus: 'تم التسليم',
              color: context.color.tertiary,
              outputsList: [
                'ميثاق المشروع (من ٢٢ ابريل ٢٠٢٤ الي ٢٢ يونيو ٢٠٢٢ )',
                'ميثاق المشروع (من ٢٢ ابريل ٢٠٢٤ الي ٢٢ يونيو ٢٠٢٢ )',
                'ميثاق المشروع (من ٢٢ ابريل ٢٠٢٤ الي ٢٢ يونيو ٢٠٢٢ )',
              ],
            ),
            SizedBox(height: 12.h),
            _OutputCardWidget(
              outputStatus: 'جاري التسليم',
              color: context.color.secondary,
              outputsList: [
                'ميثاق المشروع (من ٢٢ ابريل ٢٠٢٤ الي ٢٢ يونيو ٢٠٢٢ )',
                'وثيقه متطلبات الأعمال Business Requirement Document     (BRD)(من ٢٢ ابريل ٢٠٢٤ الي ٢٢ يونيو ٢٠٢٢ )',
              ],
            ),
            SizedBox(height: 12.h),
            _OutputCardWidget(
              outputStatus: 'لم يتم التسليم',
              color: context.color.error,
              outputsList: [
                'وثيقه متطلبات الأعمال Business Requirement Document     (BRD)(من ٢٢ ابريل ٢٠٢٤ الي ٢٢ يونيو ٢٠٢٢ ) وثيقه متطلبات الأعمال Business Requirement Document',
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _OutputCardWidget extends StatelessWidget {
  final String outputStatus;
  final Color color;
  final List<String> outputsList;

  const _OutputCardWidget({
    required this.outputStatus,
    required this.color,
    required this.outputsList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
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
                  outputStatus,
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
                  '${outputsList.length} ${allTranslations.text(LocaleKeys.outputs)}',
                  style: context.textTheme.labelSmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 8.h),
            child: Divider(color: color.withValues(alpha: 0.1)),
          ),
          ListAnimator(
            data: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: color.withValues(alpha: 0.1),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'ميثاق المشروع (من ٢٢ ابريل ٢٠٢٤ الي ٢٢ يونيو ٢٠٢٢ )',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
