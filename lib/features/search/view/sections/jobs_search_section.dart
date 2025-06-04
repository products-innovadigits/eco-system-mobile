import 'package:eco_system/features/search/bloc/search_bloc.dart';
import 'package:eco_system/utility/export.dart';

class JobsSearchSection extends StatelessWidget {
  const JobsSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<SearchBloc>();
        final jobsList = bloc.jobsList;
        final jobsBloc = context.read<JobsBloc>();
        if (state is Loading) return LoadingShimmerList();
        if (state is Done)
          return StreamBuilder<int?>(
              stream: jobsBloc.updateExpandedStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Expanded(
                        child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: jobsList.length,
                      controller: bloc.scrollController,
                      itemBuilder: (context, index) {
                        return JobCardWidget(
                            isExpanded: snapshot.data == index,
                            index: index,
                            jobDataModel: jobsList[index]);
                      },
                      separatorBuilder: (context, index) => 16.sh,
                    )),
                    CustomLoading(isTextLoading: true, loading: state.loading)
                  ],
                );
              });
        if (state is Empty || state is Error) {
          return EmptyContainer(
            txt: allTranslations.text("oops"),
            subText: allTranslations.text(state is Error
                ? LocaleKeys.something_went_wrong
                : LocaleKeys.there_is_no_data),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
