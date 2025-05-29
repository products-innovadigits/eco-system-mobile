
import 'package:eco_system/features/ats/profile/view/sections/add_rating_tab_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/rating_tabs_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/ratings_tab_section.dart';
import 'package:eco_system/utility/export.dart';

class RatingsBottomSheet extends StatelessWidget {
  const RatingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BottomSheetHeader(title: LocaleKeys.rating),
            24.sh,
            RatingTabsSection(),
            profileBloc.selectedRatingTabIndex == 0
                ? AddRatingTabSection()
                : RatingsSection(),
            24.sh,
          ],
        );
      },
    );
  }
}
