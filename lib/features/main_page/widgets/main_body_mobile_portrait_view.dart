import 'package:ats_system/jobs/view/sections/available_jobs_section.dart';
import 'package:ats_system/talent_pool/view/sections/talent_pool_section.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/features/project_categories_progress/view/project_category_progress_section.dart';
import 'package:pms_system/features/projects_progress/view/project_management_section.dart';
import 'package:strategy_system/objective_percentage/view/objective_percentage_section.dart';

class MainBodyMobilePortraitView extends StatelessWidget {
  const MainBodyMobilePortraitView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            SizedBox(height: 70),
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.strategy))
              ObjectivePercentageSection(),
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms)) ...[
              ProjectManagementSection(),
              ProjectCategoryProgressSection(),
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
