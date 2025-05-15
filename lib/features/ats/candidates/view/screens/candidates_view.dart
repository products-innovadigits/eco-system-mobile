import 'package:eco_system/utility/export.dart';

class Candidates extends StatelessWidget {
  const Candidates({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidatesBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<CandidatesBloc>();
        final filtrationBloc = context.read<FiltrationBloc>();
        return Scaffold(
          appBar: CustomAppBar(
              title: allTranslations.text(LocaleKeys.candidates),
              withSearch: true,
              withFilter: true,
              onFiltering: () {
                PopUpHelper.showBottomSheet(
                    child: BlocProvider.value(
                      value: filtrationBloc..reset(),
                      child: CandidatesFilterBottomSheet(),
                    ));
              },
              onTapSearch: () => CustomNavigator.push(Routes.SEARCH),
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
