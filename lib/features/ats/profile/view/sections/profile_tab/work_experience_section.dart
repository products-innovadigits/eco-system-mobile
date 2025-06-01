import 'package:eco_system/features/ats/profile/view/widgets/profile_tab/experience_education_card_widget.dart';
import 'package:eco_system/utility/export.dart';

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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                        color: Styles.WHITE_COLOR,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Styles.BORDER)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => profileBloc.add(Expand(arguments: 0)),
                          child: Row(
                            children: [
                              Text(
                                  allTranslations
                                      .text(LocaleKeys.work_experience),
                                  style: AppTextStyles.w500),
                              // if(experienceList.isNotEmpty)...[
                              //   4.sw,
                              //   Text(
                              //       '(اكثر من ٣ ${allTranslations.text(LocaleKeys.years)})',
                              //       style: AppTextStyles.w500
                              //           .copyWith(color: Styles.PRIMARY_COLOR)),
                              // ],
                              const Spacer(),
                              Icon(
                                  profileBloc.isWorkExperienceExpanded == false
                                      ? Icons.keyboard_arrow_down_rounded
                                      : Icons.keyboard_arrow_up_rounded,
                                  color: profileBloc.isWorkExperienceExpanded ==
                                          false
                                      ? Styles.ICON_GREY_COLOR
                                      : Styles.PRIMARY_COLOR),
                            ],
                          ),
                        ),
                        if (profileBloc.isWorkExperienceExpanded == true) ...[
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  ExperienceCardWidget(
                                      experience: experienceList[index]),
                              separatorBuilder: (context, index) => 24.sh,
                              itemCount: experienceList.length),
                        ]
                      ],
                    ),
                  );
      },
    );
  }
}
