import 'package:ats_package/profile/view/widgets/profile_tab/education_card_widget.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

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
            ? CustomShimmerContainer(
                height: 60,
                borderRadius: 8,
              )
            : educationList.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: context.w,
                    decoration: BoxDecoration(
                        color: Styles.WHITE_COLOR,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Styles.BORDER)),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
                      title: Text(allTranslations.text(LocaleKeys.education),
                          style: context.textTheme.titleMedium),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      iconColor: context.color.onSurfaceVariant,
                      collapsedIconColor: context.color.outline,
                      collapsedTextColor: context.color.onSurface,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w)
                              .copyWith(bottom: 16.h),
                          child: ListAnimator(
                            separatorPadding: 24.h,
                            data: List.generate(
                              educationList.length,
                              (index) => EducationCardWidget(
                                  educationModel: educationList[index]),
                            ),
                          ),
                          // child: ListView.separated(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     itemBuilder: (context, index) =>
                          //         EducationCardWidget(
                          //             educationModel: educationList[index]),
                          //     separatorBuilder: (context, index) => 24.sh,
                          //     itemCount: educationList.length),
                        ),
                      ],
                    ),
                  );
      },
    );
  }
}
