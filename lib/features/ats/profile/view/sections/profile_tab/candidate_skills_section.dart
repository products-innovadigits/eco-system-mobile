import 'package:eco_system/utility/export.dart';

class CandidateSkillsSection extends StatelessWidget {
  const CandidateSkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> skills =
        context.read<ProfileBloc>().candidateModel?.profile?.skills ?? [];
    return skills.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                allTranslations.text(LocaleKeys.skills),
                style: AppTextStyles.w700,
              ),
              8.sh,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(
                  skills.length,
                  (index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      skills[index],
                      style: AppTextStyles.w400.copyWith(
                        fontSize: 10,
                        color: Styles.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
