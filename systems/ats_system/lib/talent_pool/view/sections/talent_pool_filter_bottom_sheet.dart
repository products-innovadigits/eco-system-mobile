import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';


class TalentPoolFilterBottomSheet extends StatelessWidget {
  const TalentPoolFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AtsFiltrationBloc, AppState>(
      builder: (context, state) {
        final filterBloc = context.read<AtsFiltrationBloc>();
        final talentBloc = context.read<TalentPoolBloc>();
        return StreamBuilder<CandidateFilterModel>(
            stream: filterBloc.filterStream,
            builder: (context, snapshot) {
              final filterModel = snapshot.data ?? filterBloc.filterModel;
              return Stack(
                children: [
                  Column(
                    children: [
                      BottomSheetHeader(title: allTranslations.text(LocaleKeys.candidate)),
                      AtsFilterBottomSheetBody(filterModel: filterModel),
                    ],
                  ),
                  FilterButtonsSection(
                    filterModel: filterModel,
                    onApplyFilters: () =>
                        filterBloc.applyFilters(talentBloc: talentBloc),
                    onResetFilters: () =>
                        filterBloc.resetFilters(talentBloc: talentBloc),
                    isFiltered: talentBloc.isFiltered,
                  )
                ],
              );
            });
      },
    );
  }
}
