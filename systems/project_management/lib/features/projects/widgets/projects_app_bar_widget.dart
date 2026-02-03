import 'package:project_management/core/utility/pms_exports.dart';

class ProjectsAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final ProjectsBloc bloc;
  final ProjectsSortingBloc sortingBloc;
  final TextEditingController searchController;
  final bool isPortrait;

  const ProjectsAppBarWidget({
    super.key,
    required this.bloc,
    required this.sortingBloc,
    required this.searchController,
    this.isPortrait = true,
  });

  @override
  Size get preferredSize => Size(
    CustomNavigator.navigatorState.currentContext!.w,
    isPortrait ? 122.h : 200.h, // withSearch is true, so height is 122.h
  );

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to react to sorting state changes
    return BlocBuilder<ProjectsSortingBloc, ProjectsSortingState>(
      builder: (context, sortingState) {
        return BlocBuilder<ProjectsFiltrationBloc, ProjectsFiltrationState>(
          builder: (context, filtrationState) {
            final projectsFiltrationBloc = context.read<ProjectsFiltrationBloc>();
            final isFiltered = filtrationState is ProjectsFiltrationLoaded
                ? filtrationState.isFilterApplied
                : false;

            return CustomAppBar(
              title: allTranslations.text(LocaleKeys.projects),
              withSearch: true,
              withFilter: true,
              isFiltered: isFiltered,
              isSorted: sortingBloc.hasAppliedSorting,
              withSorting: true,
              withCancelBtn: true,
              onSearching: (value) => bloc.add(SearchChanged(value)),
              onCanceling: () => bloc.add(const SearchChanged('')),
              searchController: searchController,
              searchHintText: allTranslations.text(LocaleKeys.search_hint),
              onFiltering: () {
                if (!isFiltered) {
                  projectsFiltrationBloc.resetFilters(projectsBloc: bloc);
                }
                projectsFiltrationBloc.loadFilterOptions();
                PopUpHelper.showBottomSheet(
                  header: allTranslations.text(LocaleKeys.filtration),
                  child: BlocProvider.value(
                    value: bloc,
                    child: ProjectsFilterBottomSheet(),
                  ),
                );
              },
              onSorting: () {
                // Clear selection if no applied sorting
                if (!sortingBloc.hasAppliedSorting) {
                  sortingBloc.add(ClearSortingSelection());
                }
                // Load sorting options
                sortingBloc.add(LoadSortingOptions());
                PopUpHelper.showBottomSheet(
                  header: allTranslations.text(LocaleKeys.sort),
                  child: BlocProvider.value(
                    value: sortingBloc,
                    child: const ProjectsSortingBottomSheet(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
