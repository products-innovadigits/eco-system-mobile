
import 'package:eco_system/utility/export.dart';

class ProfileBodySection extends StatelessWidget {
  final bool isCandidate;
  const ProfileBodySection({super.key, required this.isCandidate});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final selectedTab =
            context.select((ProfileBloc bloc) => bloc.selectedTab);
        return Expanded(
          child: Column(
            children: [
              ProfileTabsSection(isCandidate: isCandidate),
              20.sh,
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _getTabSection(selectedTab , context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getTabSection(ProfileEnum selectedTab , BuildContext context) {
    switch (selectedTab) {
      case ProfileEnum.answers:
        return AnswersSection();
      case ProfileEnum.events:
        return EventsSection();
      case ProfileEnum.profile:
      default:
        return ProfileSection();
    }
  }
}
