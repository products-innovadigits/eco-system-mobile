import 'package:ats_system/profile/view/sections/add_rating_tab_section.dart';
import 'package:ats_system/profile/view/sections/rating_tabs_section.dart';
import 'package:ats_system/profile/view/sections/ratings_tab_section.dart';
import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';


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
            BottomSheetHeader(title: allTranslations.text(LocaleKeys.rating)),
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
