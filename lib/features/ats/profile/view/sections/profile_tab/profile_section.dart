
import 'package:eco_system/utility/export.dart';

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
