import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/features/ats/candidates/view/sections/all_candidates_section.dart';
import 'package:eco_system/features/ats/candidates/view/sections/candidates_filter_bottom_sheet.dart';
import 'package:eco_system/utility/export.dart';

class Candidates extends StatelessWidget {
  const Candidates({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidatesBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<CandidatesBloc>();
        return Scaffold(
          appBar: CustomAppBar(
              title: allTranslations.text(LocaleKeys.candidates),
              withSearch: true,
              withFilter: true,
              isFiltered: bloc.isFiltered,
              onFiltering: () {
                context.read<FiltrationBloc>().collapseExpandedLists();
                PopUpHelper.showBottomSheet(
                    child: BlocProvider.value(
                      value: bloc,
                      child: CandidatesFilterBottomSheet(),
                    ));
              },
              onTapSearch: () => CustomNavigator.push(Routes.SEARCH , arguments: SearchEnum.candidates),
              searchHintText:
              allTranslations.text(LocaleKeys.searching_for_candidate)),
          body: SingleChildScrollView(
            controller: bloc.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: AllCandidatesSection(),
          ),
        );
      },
    );
  }
}
