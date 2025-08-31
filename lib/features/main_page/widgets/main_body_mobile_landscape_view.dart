import 'package:pms_system/shared/pms_exports.dart';

class MainBodyMobileLandscapeView extends StatelessWidget {
  const MainBodyMobileLandscapeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          spacing: 16.h,
          children: [
            100.sh,
            Row(
              children: [
                if (UserBloc.activeSystems.contains(ActiveSystemEnum.strategy))
                  Expanded(child: ObjectivePercentageSection()),
                16.sw,
                if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms))
                  Expanded(child: ProjectProgressSection(isPmsHome: false)),
              ],
            ),
            24.sh,
            Row(
              children: [
                if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms))
                  Expanded(
                    child: ProjectCategoryProgressSection(isPmsHome: false),
                  ),
                16.sw,
                if (UserBloc.activeSystems.contains(ActiveSystemEnum.ats))
                  Expanded(child: AvailableJobsSection()),
              ],
            ),
            // ProjectCategoryProgressSection(),
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.ats)) ...[
              // AvailableJobsSection(),
              TalentPoolSection(),
            ],
            16.sh,
          ],
        ),
      ),
    );
  }
}
