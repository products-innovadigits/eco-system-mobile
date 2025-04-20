import 'package:eco_system/features/ats/view/sections/jobs/available_jobs_section.dart';
import 'package:eco_system/features/ats/view/sections/talent_pool/talent_pool_section.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

import '../../objective_percentage/view/objective_percentage_section.dart';
import '../../project_categories_progress/view/project_category_progress_section.dart';
import '../../projects_progress/view/projects_progress_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: context.h * 0.15),
          AvailableJobsSection(),
          TalentPoolSection(),
          ObjectivePercentageSection(),
          ProjectsProgressSection(),
          ProjectCategoryProgressSection(),
        ],
      ),
    );
  }
}
