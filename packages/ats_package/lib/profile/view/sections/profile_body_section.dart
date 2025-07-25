import 'package:ats_package/profile/view/sections/answers_tab/answers_section.dart';
import 'package:ats_package/profile/view/sections/events_tab/events_section.dart';
import 'package:ats_package/profile/view/sections/profile_tab/profile_section.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class ProfileBodySection extends StatelessWidget {
  final bool isTalent;

  const ProfileBodySection({super.key, required this.isTalent});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final selectedTab =
            context.select((ProfileBloc bloc) => bloc.selectedTab);
        if (state is Error) {
          return EmptyContainer(
            img: Assets.svgs.error.path,
            txt: allTranslations.text(LocaleKeys.page_not_found),
            desc: allTranslations.text(LocaleKeys.page_not_found_desc),
          );
        } else {
          return Expanded(
            child: Column(
              children: [
                if (state is Done) ProfileTabsSection(isTalent: isTalent),
                20.sh,
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _getTabSection(selectedTab, isTalent),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _getTabSection(ProfileEnum selectedTab, bool isTalent) {
    switch (selectedTab) {
      case ProfileEnum.answers:
        return AnswersSection();
      case ProfileEnum.events:
        return EventsSection();
      case ProfileEnum.profile:
      default:
        return ProfileSection(isTalent: isTalent);
    }
  }
}
