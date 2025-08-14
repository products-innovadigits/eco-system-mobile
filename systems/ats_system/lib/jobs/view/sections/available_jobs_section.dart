import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class AvailableJobsSection extends StatelessWidget {
  const AvailableJobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsBloc, AppState>(
      builder: (context, state) {
        if (state is Empty) {
          return EmptyContainer();
        }
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: CustomShimmerContainer(height: context.h * 0.2, width: context.w),
          );
        } else {
          return Container(
            width: context.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: context.color.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.color.outline),
            ),
            child: Column(
              children: [
                SectionTitle(
                  title: allTranslations.text(LocaleKeys.available_jobs),
                  withView: true,
                  onViewTap: () {
                    context.read<JobsBloc>().add(
                      Click(arguments: SearchEngine()),
                    );
                    CustomNavigator.push(Routes.JOBS);
                  },
                ),
                Divider(color: context.color.outline),
                12.sh,
                state is Error
                    ? TryAgainWidget(
                        onTryAgain: () {
                          context.read<JobsBloc>().add(
                            Click(arguments: SearchEngine()),
                          );
                        },
                      )
                    : JobsListSection(isHome: true),
              ],
            ),
          );
        }
      },
    );
  }
}
