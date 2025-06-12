import 'package:eco_system/features/ats/jobs/view/sections/available_jobs_section.dart';
import 'package:eco_system/features/ats/talent_pool/view/sections/talent_pool_section.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            130.sh,
            AvailableJobsSection(),
            16.sh,
            TalentPoolSection(),
            // ObjectivePercentageSection(),
            // ProjectsProgressSection(),
            // ProjectCategoryProgressSection(),
          ],
        ),
      ),
    );
  }
}
