import 'package:core_system/core/utility/export.dart';

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            100.sh,
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.strategy))
              ObjectivePercentageSection(),
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms)) ...[
              ProjectManagementSection(),
              // ProjectCategoryProgressSection(),
              if (UserBloc.activeSystems.contains(ActiveSystemEnum.ats)) ...[
                AvailableJobsSection(),
                TalentPoolSection(),
              ],
              16.sh,
            ],
          ],
        ),
      ),
    );
  }
}
