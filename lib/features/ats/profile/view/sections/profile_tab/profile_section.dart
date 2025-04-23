import 'package:eco_system/features/ats/profile/view/sections/profile_tab/candidate_compatibility_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_tab/candidate_info_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_tab/candidate_skills_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_tab/career_obj_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_tab/education_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_tab/work_experience_section.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        CandidateCompatibilitySection(),
        CandidateInfoSection(),
        CandidateSkillsSection(),
        WorkExperienceSection(),
        EducationSection(),
        CareerObjSection(),
        16.sh,
      ],
    );
  }
}
