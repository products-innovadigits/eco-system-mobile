import 'package:eco_system/features/ats/jobs/view/sections/jobs_list_section.dart';
import 'package:eco_system/utility/export.dart';

class JobsView extends StatelessWidget {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: allTranslations.text(LocaleKeys.jobs),
        withSearch: true,
        withCancelBtn: true,
        onCanceling: () => context.read<JobsBloc>().onCancelSearch(),
        // onTapSearch: () =>
        //     CustomNavigator.push(Routes.SEARCH, arguments: SearchEnum.jobs),
        searchHintText: allTranslations.text(LocaleKeys.searching_for_job),
        searchController: context.read<JobsBloc>().searchController,
        onSearching: (value) => context
            .read<JobsBloc>()
            .add(Click(arguments: SearchEngine(searchText: value))),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: BlocBuilder<JobsBloc, AppState>(
          builder: (context, state) {
            if (state is Loading) return LoadingShimmerList();
            if (state is Done) {
              return Column(
                children: [
                  Expanded(child: JobsListSection()),
                  CustomLoading(isTextLoading: true, loading: state.loading)
                ],
              );
            }
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
        ),
      ),
    );
  }
}
