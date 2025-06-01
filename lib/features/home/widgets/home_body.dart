import 'package:eco_system/features/ats/jobs/view/sections/available_jobs_section.dart';
import 'package:eco_system/features/ats/talent_pool/view/sections/talent_pool_section.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.h * 0.16),
            AvailableJobsSection(),
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
