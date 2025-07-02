import 'package:ats_package/profile/view/sections/profile_tab/candidate_compatibility_section.dart';
import 'package:ats_package/profile/view/sections/profile_tab/candidate_info_section.dart';
import 'package:ats_package/profile/view/sections/profile_tab/candidate_skills_section.dart';
import 'package:ats_package/profile/view/sections/profile_tab/certificates_section.dart';
import 'package:ats_package/profile/view/sections/profile_tab/education_section.dart';
import 'package:ats_package/profile/view/sections/profile_tab/work_experience_section.dart';
import 'package:core_package/core/utility/export.dart';

class ProfileSection extends StatelessWidget {
  final bool isTalent;
  const ProfileSection({super.key, required this.isTalent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
       if(!isTalent) CandidateCompatibilitySection(),
        CandidateInfoSection(),
        CandidateSkillsSection(),
        WorkExperienceSection(),
        EducationSection(),
        CertificatesSection(),
        16.sh,
      ],
    );
  }
}
