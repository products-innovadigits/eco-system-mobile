import 'package:ats_package/jobs/view/sections/available_jobs_section.dart';
import 'package:ats_package/talent_pool/view/sections/talent_pool_section.dart';
import 'package:core_package/core/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:pms_package/project_categories_progress/view/project_category_progress_section.dart';
import 'package:pms_package/projects_progress/view/projects_progress_section.dart';
import 'package:strategy_package/objective_percentage/view/objective_percentage_section.dart';

class HomeBody extends StatelessWidget {
  final List<String> systems;

  const HomeBody({super.key, required this.systems});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            115.sh,
            if (systems.contains('strategy')) ObjectivePercentageSection(),
            if (systems.contains('pms')) ...[
              ProjectsProgressSection(),
              ProjectCategoryProgressSection(),
              if (systems.contains('ats')) ...[
                AvailableJobsSection(),
                TalentPoolSection(),
              ],
              16.sh
            ],
          ],
        ),
      ),
    );
  }
}
