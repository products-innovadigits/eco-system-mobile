import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/cycles_bloc.dart';
import 'package:pms_system/features/cycles/bloc/cycles_events.dart';
import 'package:pms_system/features/cycles/bloc/filtration/cycles_filtration_bloc.dart';
import 'package:pms_system/features/cycles/bloc/filtration/cycles_filtration_state.dart';
import 'package:pms_system/features/cycles/widgets/cycles_filter/cycles_filter_bottom_sheet.dart';

class CyclesAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final CyclesBloc bloc;
  final TextEditingController searchController;
  final bool isPortrait;

  const CyclesAppBarWidget({
    super.key,
    required this.bloc,
    required this.searchController,
    this.isPortrait = true,
  });

  @override
  Size get preferredSize => Size(
    CustomNavigator.navigatorState.currentContext!.w,
    isPortrait ? 122.h : 200.h,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CyclesFiltrationBloc, CyclesFiltrationState>(
      builder: (context, filtrationState) {
        final filtrationBloc = context.read<CyclesFiltrationBloc>();
        final isFiltered = filtrationState is CyclesFiltrationLoaded
            ? filtrationState.isFilterApplied
            : false;

        return CustomAppBar(
          title: allTranslations.text(LocaleKeys.cycles),
          withSearch: true,
          withFilter: true,
          isFiltered: isFiltered,
          withCancelBtn: true,
          onSearching: (value) => bloc.add(SearchChanged(value)),
          onCanceling: () => bloc.add(const SearchChanged('')),
          searchController: searchController,
          searchHintText: allTranslations.text(LocaleKeys.search_hint),
          onFiltering: () {
            if (!isFiltered) {
              filtrationBloc.clearFilters();
            }
            filtrationBloc.loadFilterOptions();
            PopUpHelper.showBottomSheet(
              header: allTranslations.text(LocaleKeys.filtration),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<CyclesBloc>.value(value: bloc),
                  BlocProvider<CyclesFiltrationBloc>.value(
                    value: filtrationBloc,
                  ),
                ],
                child: const CyclesFilterBottomSheet(),
              ),
            );
          },
        );
      },
    );
  }
}
