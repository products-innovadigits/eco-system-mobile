import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CandidatesFilterBottomSheet extends StatelessWidget {
  const CandidatesFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final filterBloc = context.read<FiltrationBloc>();
        final candidateBloc = context.read<CandidatesBloc>();
        return StreamBuilder<CandidateFilterModel>(
            stream: filterBloc.filterStream,
            builder: (context, snapshot) {
              final filterModel = snapshot.data ?? filterBloc.filterModel;
              return Stack(
                children: [
                  Column(
                    children: [
                      BottomSheetHeader(title: allTranslations.text(LocaleKeys.candidate)),
                      FilterBottomSheetBody(filterModel: filterModel),
                    ],
                  ),
                  FilterButtonsSection(
                    filterModel: filterModel,
                    onApplyFilters: () =>
                        filterBloc.applyFilters(candidatesBloc: candidateBloc),
                    onResetFilters: () =>
                        filterBloc.resetFilters(candidatesBloc: candidateBloc),
                    isFiltered: candidateBloc.isFiltered,
                  )
                ],
              );
            });
      },
    );
  }
}
