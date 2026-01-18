import 'package:ats_system/profile/view/sections/events_tab/event_details_card_widget.dart';
import 'package:core_system/core/utility/export.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => EventDetailsCardWidget(),
      separatorBuilder: (context, index) => SizedBox(height: 28.h),
      itemCount: 4,
    );
  }
}
