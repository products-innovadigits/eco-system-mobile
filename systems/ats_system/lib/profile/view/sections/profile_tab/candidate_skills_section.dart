import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class CandidateSkillsSection extends StatelessWidget {
  const CandidateSkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final List<String> skills =
            context.read<ProfileBloc>().candidateModel?.profile?.skills ?? [];
        return state is Loading
            ? CustomShimmerContainer(height: 60, borderRadius: 8)
            : skills.isEmpty
            ? const SizedBox.shrink()
            : Container(
                width: context.w,
                decoration: BoxDecoration(
                  color: context.color.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.color.outline),
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
                  expansionAnimationStyle: AnimationStyle(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                  title: Text(
                    allTranslations.text(LocaleKeys.skills),
                    style: context.textTheme.titleMedium,
                  ),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  iconColor: context.color.secondary,
                  collapsedIconColor: context.color.outlineVariant,
                  collapsedTextColor: context.color.onSurface,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ).copyWith(bottom: 16.h),
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: List.generate(
                          skills.length,
                          (index) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: context.color.secondary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              skills[index],
                              style: context.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
