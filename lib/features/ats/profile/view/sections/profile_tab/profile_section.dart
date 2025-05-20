
import 'package:eco_system/utility/export.dart';

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
        CareerObjSection(),
        16.sh,
      ],
    );
  }
}
