import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';

class ObjectiveDetailsDescription extends StatelessWidget {
  const ObjectiveDetailsDescription({
    super.key,
    this.description,
    this.startDate,
    required this.endDate,
  });

  final String? description;
  final DateTime? startDate, endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description ?? "",
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall,
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.color.secondary.withValues(alpha: 0.1),
                    ),
                    child: Images(
                      image: Assets.svgs.calendar.path,
                      width: 16.w,
                      height: 16.w,
                      color: context.color.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allTranslations.text("start_date"),
                        textAlign: TextAlign.start,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.color.outlineVariant,
                          fontSize: FontSizes.f10,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        (startDate ?? DateTime.now()).format("d MMM yyyy"),
                        textAlign: TextAlign.start,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.color.secondary.withValues(alpha: 0.1),
                    ),
                    child: Images(
                      image: Assets.svgs.calendarTick.path,
                      width: 16.w,
                      height: 16.w,
                      color: context.color.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allTranslations.text("end_date"),
                          textAlign: TextAlign.end,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.outlineVariant,
                            fontSize: FontSizes.f10,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          (endDate ?? DateTime.now()).format("d MMM yyyy"),
                          textAlign: TextAlign.end,
                          style: context.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
