import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class JobsListSection extends StatelessWidget {
  final bool? isHome;

  const JobsListSection({super.key, this.isHome = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsBloc, AppState>(
      builder: (context, state) {
        final jobsBloc = context.read<JobsBloc>();

        return StreamBuilder<int?>(
            stream: jobsBloc.updateExpandedStream,
            builder: (context, snapshot) {
              return ListView.separated(
                  controller:
                      isHome == false ? jobsBloc.scrollController : null,
                  shrinkWrap: isHome == false ? false : true,
                  physics: isHome == false
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final JobDataModel jobDataModel = jobsBloc.jobsList[index];
                    return JobCardWidget(
                        isExpanded: snapshot.data == index,
                        index: index,
                        jobDataModel: jobDataModel);
                  },
                  separatorBuilder: (context, index) => 16.sh,
                  itemCount: (isHome == false)
                      ? jobsBloc.jobsList.length
                      : jobsBloc.jobsList.length > 2
                          ? 2
                          : jobsBloc.jobsList.length);
            });
      },
    );
  }
}
