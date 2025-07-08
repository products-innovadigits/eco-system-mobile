import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

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
            decoration: BoxDecoration(
                color: Styles.WHITE_COLOR,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.color.outline)),
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
                Divider(color: context.color.outline),
                12.sh,
                JobsListSection(isHome: true),
              ],
            ),
          );
        }
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: CustomShimmerContainer(
                height: context.h * 0.2, width: context.w),
          );
        }
        if (state is Error) {
          return Padding(
            padding: EdgeInsets.only(top: 24.h , right: 16.w, left: 16.w),
            child: ErrorContainerWidget(
                header: Column(
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
                    Divider(color: context.color.outline),
                  ],
                ),
                onTryAgain: () {
                  context
                      .read<JobsBloc>()
                      .add(Click(arguments: SearchEngine()));
                }),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: EmptyContainer(
              txt: allTranslations.text(LocaleKeys.there_is_no_data),
            ),
          );
        }
      },
    );
  }
}
