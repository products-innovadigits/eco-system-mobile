import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class ProfileTabsSection extends StatelessWidget {
  final bool isTalent;

  const ProfileTabsSection({super.key, required this.isTalent});

  static Map<ProfileEnum, String> applicantTabTitles = {
    ProfileEnum.profile: LocaleKeys.profile,
    ProfileEnum.events: LocaleKeys.events,
    ProfileEnum.answers: LocaleKeys.answers,
  };

  static Map<ProfileEnum, String> talentTabTitles = {
    ProfileEnum.profile: LocaleKeys.profile,
    ProfileEnum.events: LocaleKeys.events,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          (isTalent ? talentTabTitles : applicantTabTitles).keys.map((tab) {
        return CustomTabWidget(
          title: applicantTabTitles[tab] ?? '',
          isSelected: context.watch<ProfileBloc>().selectedTab == tab,
          onTap: () {
            context.read<ProfileBloc>().add(Select(arguments: tab));
          },
        );
      }).toList(),
    );
  }
}
