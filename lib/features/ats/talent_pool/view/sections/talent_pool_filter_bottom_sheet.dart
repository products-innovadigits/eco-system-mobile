import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/features/ats/talent_pool/view/sections/filter_bottom_sheet_body.dart';
import 'package:eco_system/features/ats/talent_pool/view/sections/filter_buttons_section.dart';
import 'package:eco_system/utility/export.dart';

class TalentPoolFilterBottomSheet extends StatelessWidget {
  const TalentPoolFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final filterBloc = context.read<FiltrationBloc>();
        final talentBloc = context.read<TalentPoolBloc>();
        return StreamBuilder<CandidateFilterModel>(
            stream: filterBloc.filterStream,
            builder: (context, snapshot) {
              final filterModel = snapshot.data ?? filterBloc.filterModel;
              return Stack(
                children: [
                  Column(
                    children: [
                      BottomSheetHeader(title: LocaleKeys.candidate),
                      FilterBottomSheetBody(filterModel: filterModel),
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
