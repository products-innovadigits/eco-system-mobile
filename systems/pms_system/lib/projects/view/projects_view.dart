import 'package:pms_system/shared/pms_exports.dart';
import 'package:core_system/core/components/system_switcher.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectsBloc()..add(Click(arguments: SearchEngine())),
      child: BlocBuilder<ProjectsBloc, AppState>(
        builder: (context, state) {
          final bloc = context.read<ProjectsBloc>();
          final projectsFiltrationBloc = context.read<ProjectsFiltrationBloc>();
          return Scaffold(
            appBar: CustomAppBar(
              title: allTranslations.text(LocaleKeys.projects),
              withSearch: true,
              withFilter: true,
              isFiltered: projectsFiltrationBloc.isFilterApplied,
              // isSorted: bloc.appliedSorting != null,
              withSorting: true,
              withCancelBtn: true,
              onSearching: (value) =>
                  bloc.add(Click(arguments: SearchEngine())),
              // onCanceling: () => bloc.onCancelSearch(),
              searchController: bloc.searchTEC,
              searchHintText: allTranslations.text(LocaleKeys.search_hint),
              onFiltering: () {
                PopUpHelper.showBottomSheet(
                  child: BlocProvider.value(
                    value: bloc,
                    child: ProjectsFilterBottomSheet(),
                  ),
                );
              },
              onSorting: () {
                //   PopUpHelper.showBottomSheet(
                //   child: BlocProvider.value(
                //     value: context.read<TalentPoolBloc>(),
                //     child: const SortingBottomSheet(),
                //   ),
                // );
              },
            ),
            body: SafeArea(
              child: BlocBuilder<ProjectsBloc, AppState>(
                builder: (context, state) {
                  return switch (state) {
                    // Loading…
                    Error() => EmptyContainer(
                      img: Assets.svgs.error.path,
                      txt: allTranslations.text(
                        LocaleKeys.something_went_wrong,
                      ),
                    ),

                    // Done
                    Done(:final cards, :final loading) => Column(
                      children: [
                        Expanded(
                          child: ListAnimator(
                            customPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            controller: context
                                .read<ProjectsBloc>()
                                .scrollController,
                            data: cards,
                          ),
                        ),
                        CustomLoading(isTextLoading: true, loading: loading),
                      ],
                    ),

                    // Empty
                    Empty() => EmptyContainer(),

                    // Fallback (in case error occurs or something else)
                    _ => SystemsSwitcher(
                      title: 'title',
                      subtitle: 'subtitle',
                      systemRoute: Routes.PROJECTS,
                    ),
                  };
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
