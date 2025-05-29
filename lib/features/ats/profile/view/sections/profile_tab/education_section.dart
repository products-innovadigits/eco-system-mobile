import 'package:eco_system/features/ats/profile/view/widgets/profile_tab/education_card_widget.dart';
import 'package:eco_system/utility/export.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        final List<EducationModel> educationList =
            profileBloc.candidateModel?.profile?.education ?? [];
        return state is Loading
            ? CustomShimmerContainer(height: 60 , borderRadius: 8,)
            : educationList.isEmpty
            ? const SizedBox.shrink()
            : Container(
                width: context.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                    color: Styles.WHITE_COLOR,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Styles.BORDER)),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => profileBloc.add(Expand(arguments: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(allTranslations.text(LocaleKeys.education),
                              style: AppTextStyles.w500),
                          Icon(
                              profileBloc.isEducationExpanded == false
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up_rounded,
                              color: profileBloc.isEducationExpanded == false
                                  ? Styles.ICON_GREY_COLOR
                                  : Styles.PRIMARY_COLOR),
                        ],
                      ),
                    ),
                    if (profileBloc.isEducationExpanded == true) ...[
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => EducationCardWidget(
                              educationModel: educationList[index]),
                          separatorBuilder: (context, index) => 24.sh,
                          itemCount: educationList.length),
                    ]
                  ],
                ),
              );
      },
    );
  }
}
