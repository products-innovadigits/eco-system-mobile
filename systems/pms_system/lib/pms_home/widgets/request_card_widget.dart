import '../../shared/pms_exports.dart';

class RequestCardWidget extends StatelessWidget {
  const RequestCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.secondary.withOpacity(0.1)),
          child: Images(
              image: Assets.svgs.request.path,
              width: 16.w,
              height: 16.w,
              color: context.color.primary),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                        'إنشاء طلب المشروع – الإدارة العامة للتخطيط الاستراتيجي (SPD)',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelSmall),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: context.color.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text("غير مكتملة",
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: context.color.secondary)),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'تاريخ الطلب: Jan 15, 2025 - 10:30 AM',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
