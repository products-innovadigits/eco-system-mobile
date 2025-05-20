
import 'package:eco_system/utility/export.dart';

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
