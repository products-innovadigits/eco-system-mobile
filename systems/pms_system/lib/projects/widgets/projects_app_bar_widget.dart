import 'package:pms_system/projects/bloc/filtration/projects_filtration_state.dart';
import 'package:pms_system/projects/bloc/projects/projects_events.dart';
import 'package:pms_system/projects/bloc/sorting/projects_sorting_bloc.dart';
import 'package:pms_system/projects/bloc/sorting/projects_sorting_events.dart';
import 'package:pms_system/projects/bloc/sorting/projects_sorting_states.dart';
import 'package:pms_system/projects/widgets/projects_sorting_bottom_sheet.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectsAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final ProjectsBloc bloc;
  final ProjectsSortingBloc sortingBloc;

  const ProjectsAppBarWidget({
    super.key,
    required this.bloc,
    required this.sortingBloc,
  });

  @override
  Size get preferredSize => Size(
    CustomNavigator.navigatorState.currentContext!.w,
    122.h, // withSearch is true, so height is 122.h
  );

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to react to sorting state changes
    return BlocBuilder<ProjectsSortingBloc, ProjectsSortingState>(
      builder: (context, sortingState) {
        return BlocBuilder<ProjectsFiltrationBloc, ProjectsFiltrationState>(
          builder: (context, filtrationState) {
            final projectsFiltrationBloc = ProjectsFiltrationBloc.instance;
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
              onSearching: (value) =>
                  bloc.add(LoadProjects(searchEngine: SearchEngine())),
              onCanceling: () =>
                  bloc.add(LoadProjects(searchEngine: SearchEngine())),
              searchController: bloc.searchTEC,
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
