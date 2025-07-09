import 'package:ats_package/profile/view/widgets/profile_tab/experience_education_card_widget.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class WorkExperienceSection extends StatelessWidget {
  const WorkExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        final List<ExperienceModel> experienceList =
            profileBloc.candidateModel?.profile?.experience ?? [];
        return state is Loading
            ? CustomShimmerContainer(
                height: 60,
                borderRadius: 8,
              )
            : experienceList.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: context.w,
                    decoration: BoxDecoration(
                      color: context.color.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Styles.BORDER),
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
                      title: Text(
                          allTranslations.text(LocaleKeys.work_experience),
                          style: context.textTheme.titleMedium),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      iconColor: context.color.secondary,
                      collapsedIconColor: context.color.outline,
                      collapsedTextColor: context.color.onSurface,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w)
                              .copyWith(bottom: 16.h),
                          child: ListAnimator(
                            separatorPadding: 24.h,
                            data: List.generate(
                              experienceList.length,
                              (index) => ExperienceCardWidget(
                                  experience: experienceList[index]),
                            ),
                          ),
                          // child: ListView.separated(
                          //   shrinkWrap: true,
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   itemBuilder: (context, index) =>
                          //       ExperienceCardWidget(
                          //           experience: experienceList[index]),
                          //   separatorBuilder: (context, index) => 24.sh,
                          //   itemCount: experienceList.length,
                          // ),
                        ),
                      ],
                    ),
                  );
      },
    );
  }
}
