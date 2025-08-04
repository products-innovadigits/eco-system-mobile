import 'package:ats_system/jobs/view/sections/available_jobs_section.dart';
import 'package:ats_system/talent_pool/view/sections/talent_pool_section.dart';
import 'package:core_system/core/bloc/user_bloc.dart';
import 'package:core_system/core/core/enums.dart';
import 'package:core_system/core/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:pms_system/projects_progress/view/projects_progress_section.dart';
import 'package:strategy_system/objective_percentage/view/objective_percentage_section.dart';

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
            130.sh,
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.strategy))
              ObjectivePercentageSection(),
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms)) ...[
              ProjectsProgressSection(),
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
