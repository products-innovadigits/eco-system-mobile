import 'package:ats_system/jobs/view/sections/available_jobs_section.dart';
import 'package:ats_system/talent_pool/view/sections/talent_pool_section.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/projects_progress/widgets/project_progress_section.dart';
import 'package:strategy_system/objective_percentage/view/objective_percentage_section.dart';

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
