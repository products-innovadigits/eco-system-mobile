import 'package:strategy_system/shared/strategy_exports.dart';

class ObjectivesFilterBottomSheet extends StatelessWidget {
  const ObjectivesFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectivesFiltrationBloc, AppState>(
      builder: (context, state) {
        final filterBloc = context.read<ObjectivesFiltrationBloc>();
        final objectivesBloc = context.read<ObjectivesBloc>();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(
                  title: allTranslations.text(LocaleKeys.candidate),
                ),
                ObjectivesFilterBottomSheetBody(),
              ],
            ),
            ObjectivesFilterButtonsSection(
              onApplyFilters: () =>
                  filterBloc.applyFilters(objectivesBloc: objectivesBloc),
              onResetFilters: () =>
                  filterBloc.resetFilters(objectivesBloc: objectivesBloc),
              isFiltered: filterBloc.isFilterApplied,
            ),
          ],
        );
      },
    );
  }
}
