import 'package:ats_package/shared/ats_exports.dart';
import 'package:ats_package/talent_pool/view/widgets/talent_card_widget.dart';
import 'package:core_package/core/utility/export.dart';

class TalentPoolListSection extends StatelessWidget {
  const TalentPoolListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalentPoolBloc, AppState>(
      buildWhen: (previous, current) => current is! Exporting,
      builder: (context, state) {
        final bloc = context.read<TalentPoolBloc>();
        final talentsList = bloc.talentsList;
        if (state is Loading) return LoadingShimmerList();
        if (state is Done) {
          return Column(
            children: [
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  bloc.add(Click(arguments: SearchEngine()));
                },
                child: ListAnimator(
                  controller: bloc.scrollController,
                  separatorPadding: 16.h,
                  data: List.generate(
                      talentsList.length,
                      (index) => TalentCardWidget(
                            onSelectTalent: () => bloc.add(SelectTalent(
                                arguments: {
                                  "talentId": talentsList[index].id
                                })),
                            isTalentSelected: bloc.selectedTalentsList
                                .contains(talentsList[index].id),
                            isSelectionActive: bloc.activeSelection,
                            talent: talentsList[index],
                          )),
                ),
                // ListView.separated(
                //   physics: const BouncingScrollPhysics(),
                //   itemCount: talentsList.length,
                //   controller: bloc.scrollController,
                //   itemBuilder: (context, index) {
                //     return TalentCardWidget(
                //       onSelectTalent: () => bloc.add(SelectTalent(
                //           arguments: {"talentId": talentsList[index].id})),
                //       isTalentSelected: bloc.selectedTalentsList
                //           .contains(talentsList[index].id),
                //       isSelectionActive: bloc.activeSelection,
                //       talent: talentsList[index],
                //     );
                //   },
                //   separatorBuilder: (context, index) => 16.sh,
                // ),
              )),
              CustomLoading(isTextLoading: true, loading: state.loading)
            ],
          );
        }
        if (state is Empty) {
          return EmptyContainer(
            img: Assets.svgs.emptyCandidates.path,
            txt: state.initial == true
                ? allTranslations.text(LocaleKeys.no_talents)
                : allTranslations.text(LocaleKeys.there_is_no_data),
            desc: state.initial == true
                ? allTranslations.text(LocaleKeys.no_talents_desc)
                : allTranslations.text(LocaleKeys.there_is_no_data),
          );
        } else {
          return EmptyContainer(
            img: Assets.svgs.error.path,
            txt: allTranslations.text(LocaleKeys.page_not_found),
            desc: allTranslations.text(LocaleKeys.page_not_found_desc),
          );
        }
      },
    );
  }
}
