import 'package:eco_system/features/ats/profile/view/sections/events_tab/event_details_card_widget.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => EventDetailsCardWidget(),
        separatorBuilder: (context, index) => 28.sh,
        itemCount: 4);
  }
}
