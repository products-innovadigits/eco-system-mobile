import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CandidateSkillsSection extends StatelessWidget {
  const CandidateSkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final List<String> skills =
            context.read<ProfileBloc>().candidateModel?.profile?.skills ?? [];
        if (state is Loading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100.w,
                  height: 20.h,
                  color: Colors.white,
                ),
              ),
              12.sh,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(5, (index) => _buildShimmerSkill()),
              )
            ],
          );
        }

        return skills.isEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    allTranslations.text(LocaleKeys.skills),
                    style: context.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  8.sh,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(
                      skills.length,
                      (index) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: context.color.onSurfaceVariant
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skills[index],
                          style: context.textTheme.bodySmall
                              ?.copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                  )
                ],
              );
      },
    );
  }
}

Widget _buildShimmerSkill() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 40,
        height: 10,
        color: Colors.white,
      ),
    ),
  );
}
