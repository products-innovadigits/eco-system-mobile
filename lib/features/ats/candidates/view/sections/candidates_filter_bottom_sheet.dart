import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/utility/export.dart';

class CandidatesFilterBottomSheet extends StatelessWidget {
  const CandidatesFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final filterBloc = context.read<FiltrationBloc>();
        final candidateBloc = context.read<CandidatesBloc>();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.candidate),
                SizedBox(
                  height: context.h * 0.8,
                  child: StreamBuilder<CandidateFilterModel>(
                      stream: filterBloc.filterStream,
                      builder: (context, snapshot) {
                        final filterModel =
                            snapshot.data ?? filterBloc.filterModel;
                        return ListView(
                          children: [
                            Skills(selectedSkills: filterModel.selectedSkills),
                            16.sh,
                            Tags(selectedTags: filterModel.selectedTags),
                            16.sh,
                            ExpectedSalary(),
                            16.sh,
                            Experience(),
                            16.sh,
                            Location(),
                            16.sh,
                            Gender(),
                            16.sh,
                            Qualified(),
                            16.sh,
                            ApplicationDate(),
                            16.sh,
                            CompatibilityRate(),
                            60.sh
                          ],
                        );
                      }),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StreamBuilder<CandidateFilterModel>(
                stream: filterBloc.filterStream,
                builder: (context, snapshot) {
                  final filterModel = snapshot.data ?? filterBloc.filterModel;

                  return Row(
                    children: [
                      Expanded(
                        child: CustomBtn(
                          text:
                              allTranslations.text(LocaleKeys.show_all_results),
                          active: filterModel.hasActiveFilters,
                          onPressed: () => filterBloc.applyFilters(
                              candidatesBloc: candidateBloc),
                        ),
                      ),
                      if (candidateBloc.isFiltered) ...[
                        8.sw,
                        Expanded(
                          child: CustomBtn(
                            text: allTranslations.text(LocaleKeys.reset),
                            color: Styles.WHITE_COLOR,
                            textColor: Styles.PRIMARY_COLOR,
                            borderColor: Styles.PRIMARY_COLOR,
                            onPressed: () => filterBloc.resetFilters(
                                candidatesBloc: candidateBloc),
                          ),
                        ),
                      ]
                    ],
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
