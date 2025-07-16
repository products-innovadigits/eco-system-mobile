import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:eco_system/features/notifications/model/notification_model.dart';
import 'package:eco_system/features/notifications/widgets/accept_reject_btn_section.dart';
import 'package:eco_system/features/notifications/widgets/attached_file_widget.dart';
import 'package:eco_system/features/notifications/widgets/review_project_widget.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationData notificationData;

  const NotificationCardWidget({super.key, required this.notificationData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          color: context.color.surfaceContainer,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.color.secondary.withValues(alpha: 0.1),
                      border: Border.all(
                        color: context.color.secondary.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Images(
                      image: Assets.svgs.increase.path,
                      color: context.color.primary,
                    ),
                  ),
                  16.sw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notificationData.title ?? '',
                                style: context.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              notificationData.date ?? '',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.color.outlineVariant,
                              ),
                            ),
                          ],
                        ),
                        8.sh,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                notificationData.body ?? '',
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: context.color.outlineVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: context.color.primary,
                            ),
                          ],
                        ),
                        16.sh,
                        if (true) ReviewProjectWidget(),
                        if (false) AttachedFileWidget(),
                        if (false) AcceptRejectBtnSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.h , horizontal: 32.w),
          color: context.color.surfaceContainer,
          child: DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            dashGapLength: 4.w,
            dashLength: 8.w,
            dashColor: context.color.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}
