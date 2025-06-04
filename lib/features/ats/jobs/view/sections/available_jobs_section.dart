import 'package:eco_system/features/ats/jobs/view/sections/jobs_list_section.dart';
import 'package:eco_system/utility/export.dart';

class AvailableJobsSection extends StatelessWidget {
  const AvailableJobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          return Container(
            width: context.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
                color: Styles.WHITE_COLOR,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Styles.LIGHT_GREY_BORDER)),
            child: Column(
              children: [
                SectionTitle(
                  title: allTranslations.text(LocaleKeys.available_jobs),
                  withView: true,
                  onViewTap: () {
                    context
                        .read<JobsBloc>()
                        .add(Click(arguments: SearchEngine()));
                    CustomNavigator.push(Routes.JOBS);
                  },
                ),
                Divider(color: Styles.BORDER_COLOR),
                12.sh,
                JobsListSection(isHome: true),
              ],
            ),
          );
        }
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: CustomShimmerContainer(
                height: context.h * 0.2, width: context.w),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: EmptyContainer(
                txt: state is Error
                    ? allTranslations.text(LocaleKeys.something_went_wrong)
                    : allTranslations.text(LocaleKeys.there_is_no_data)),
          );
        }
      },
    );
  }
}
