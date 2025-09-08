import 'package:pms_system/shared/pms_exports.dart';

class MainBodyMobileLandscapeView extends StatelessWidget {
  const MainBodyMobileLandscapeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          spacing: 16.h,
          children: [
            SizedBox(height: 70),
            Row(
              children: [
                if (UserBloc.activeSystems.contains(ActiveSystemEnum.strategy))
                  Expanded(child: ObjectivePercentageSection()),
                const SizedBox(width: 16),
                if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms))
                  Expanded(child: ProjectProgressSection(isPmsHome: false)),
              ],
            ),
            const SizedBox(height: 24),
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
