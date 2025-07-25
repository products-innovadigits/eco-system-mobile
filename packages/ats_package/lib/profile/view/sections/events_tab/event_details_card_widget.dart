import 'package:ats_package/profile/view/sections/events_tab/follow_up_manager_details_section.dart';
import 'package:ats_package/profile/view/widgets/events_tab/test_file_widget.dart';
import 'package:core_package/core/utility/export.dart';

class EventDetailsCardWidget extends StatelessWidget {
  const EventDetailsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FollowUpManagerDetailsSection(),
        8.sh,
        Container(
          width: context.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.color.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'هشام منصور الان في ',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.outlineVariant,
                      ),
                    ),
                    TextSpan(
                      text: 'مرحلة المقابلة الشخصية ',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.tertiary,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    TextSpan(
                      text: 'ينتظر تحديد موعد الاختبار',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.color.outlineVariant,
                      ),
                    ),
                  ],
                ),
              ),
              16.sh,
              TestFileWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
