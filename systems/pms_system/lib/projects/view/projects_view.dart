import 'dart:developer';

import 'package:core_system/core/widgets/nav_app.dart';
import 'package:pms_system/projects/widgets/projects_sorting_bottom_sheet.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  int _selectedIndex = 0;

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
              isSorted: bloc.appliedSorting != null,
              withSorting: true,
              withCancelBtn: true,
              onSearching: (value) =>
                  bloc.add(Click(arguments: SearchEngine())),
              onCanceling: () => bloc.add(Click(arguments: SearchEngine())),
              searchController: bloc.searchTEC,
              searchHintText: allTranslations.text(LocaleKeys.search_hint),
              onFiltering: () {
                if (!projectsFiltrationBloc.isFilterApplied) {
                  projectsFiltrationBloc.resetFilters(projectsBloc: bloc);
                }
                PopUpHelper.showBottomSheet(
                  child: BlocProvider.value(
                    value: bloc,
                    child: ProjectsFilterBottomSheet(),
                  ),
                );
              },
              onSorting: () {
                if (bloc.appliedSorting == null) {
                  bloc.selectedSorting = null;
                }
                PopUpHelper.showBottomSheet(
                  child: BlocProvider.value(
                    value: bloc,
                    child: const ProjectsSortingBottomSheet(),
                  ),
                );
              },
            ),
            body: SafeArea(
              child: BlocBuilder<ProjectsBloc, AppState>(
                builder: (context, state) {
                  log('state: $state');
                  return switch (state) {
                    // Loading…
                    Loading() => const ShimmerCardsList(),

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
                    Empty(:final initial) => EmptyContainer(
                      txt: initial == true
                          ? null
                          : (bloc.searchTEC != null &&
                                bloc.searchTEC!.text.isEmpty)
                          ? allTranslations.text(
                              LocaleKeys.no_projects_match_your_filters,
                            )
                          : '${allTranslations.text(LocaleKeys.no_projects_match)} \' ${bloc.searchTEC!.text} \'',
                    ),

                    // Fallback (in case error occurs or something else)
                    _ => EmptyContainer(
                      img: Assets.svgs.error.path,
                      txt: allTranslations.text(
                        LocaleKeys.something_went_wrong,
                      ),
                    ),
                  };
                },
              ),
            ),
            bottomNavigationBar: NavApp(
              index: _selectedIndex,
              onSelect: (index) {
                // Handle navigation based on selected index
                switch (index) {
                  case 0:
                    CustomNavigator.push(Routes.PMS_LAYOUT);
                    break;
                  case 1:
                    /* Navigate to reports */
                    break;
                  case 2:
                    /* Navigate to notifications */
                    break;
                }

                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
