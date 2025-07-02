import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class RatingTabsSection extends StatefulWidget {
  const RatingTabsSection({super.key});

  @override
  State<RatingTabsSection> createState() => _RatingTabsSectionState();
}

class _RatingTabsSectionState extends State<RatingTabsSection> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CustomTabWidget(
        title: LocaleKeys.add_rating,
        isSelected: selectedTabIndex == 0,
        onTap: () {
          context.read<ProfileBloc>().add(SelectTab(arguments: 0));
          setState(() {
            selectedTabIndex = 0;
          });
        },
      ),
      CustomTabWidget(
        title: LocaleKeys.ratings,
        isSelected: selectedTabIndex == 1,
        onTap: () {
          context.read<ProfileBloc>().add(SelectTab(arguments: 1));
          setState(() {
            selectedTabIndex = 1;
          });
        },
      )
    ]);
  }
}
