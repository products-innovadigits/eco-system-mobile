import 'package:project_management/core/utility/pms_exports.dart';

class LatestRequestAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final LatestRequestCubit cubit;
  final LatestRequestSortingCubit sortingCubit;

  const LatestRequestAppBarWidget({
    super.key,
    required this.cubit,
    required this.sortingCubit,
  });

  @override
  Size get preferredSize =>
      Size(CustomNavigator.navigatorState.currentContext!.w, 122.h);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestRequestSortingCubit, LatestRequestSortingState>(
      builder: (context, sortingState) {
        return BlocBuilder<
          LatestRequestFiltrationCubit,
          LatestRequestFiltrationState
        >(
          builder: (context, filtrationState) {
            // final latestRequestFiltrationCubit =
            //     LatestRequestFiltrationCubit.instance;
            final isFiltered = filtrationState is LatestRequestFiltrationLoaded
                ? filtrationState.isFilterApplied
                : false;

            return CustomAppBar(
              title: allTranslations.text(LocaleKeys.requests),
              withSearch: true,
              withFilter: true,
              isFiltered: isFiltered,
              isSorted: sortingCubit.hasAppliedSorting,
              withSorting: true,
              withCancelBtn: true,
              onSearching: (value) =>
                  cubit.getLatestRequest(searchEngine: SearchEngine()),
              onCanceling: () =>
                  cubit.getLatestRequest(searchEngine: SearchEngine()),
              searchController: cubit.searchTEC,
              searchHintText: allTranslations.text(LocaleKeys.search_hint),
              onFiltering: () {
                // if (!isFiltered) {
                //   latestRequestFiltrationCubit.resetFilters(
                //     latestRequestCubit: cubit,
                //   );
                // }
                // latestRequestFiltrationCubit.loadFilterOptions();
                // PopUpHelper.showBottomSheet(
                //   header: allTranslations.text(LocaleKeys.filtration),
                //   child: MultiBlocProvider(
                //     providers: [
                //       BlocProvider.value(value: cubit),
                //       BlocProvider.value(value: sortingCubit),
                //     ],
                //     child: const LatestRequestFilterBottomSheet(),
                //   ),
                // );
              },
              onSorting: () {
                // if (!sortingCubit.hasAppliedSorting) {
                //   sortingCubit.clearSortingSelection();
                // }
                // sortingCubit.loadSortingOptions();
                // PopUpHelper.showBottomSheet(
                //   header: allTranslations.text(LocaleKeys.sort),
                //   child: BlocProvider.value(
                //     value: sortingCubit,
                //     child: const LatestRequestSortingBottomSheet(),
                //   ),
                // );
              },
            );
          },
        );
      },
    );
  }
}
