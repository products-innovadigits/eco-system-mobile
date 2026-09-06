import 'package:ats_system/shared/ats_exports.dart';
import 'package:ats_system/talent_pool/view/widgets/talent_card_widget.dart';
import 'package:core_system/core/utility/export.dart';

class TalentPoolListSection extends StatelessWidget {
  const TalentPoolListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalentPoolBloc, AppState>(
      buildWhen: (previous, current) => current is! Exporting,
      builder: (context, state) {
        final bloc = context.read<TalentPoolBloc>();
        final talentsList = bloc.talentsList;

        return switch (state) {
          // ── Loading ────────────────────────────
          Loading() => const ShimmerCardsList(),

          // ── Done ───────────────────────────────
          Done(:final loading) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
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
                          onSelectTalent: () => bloc.add(
                            SelectTalent(
                              arguments: {"talentId": talentsList[index].id},
                            ),
                          ),
                          isTalentSelected: bloc.selectedTalentsList.contains(
                            talentsList[index].id,
                          ),
                          isSelectionActive: bloc.activeSelection,
                          talent: talentsList[index],
                        ),
                      ),
                    ),
                  ),
                ),
                CustomLoading(isTextLoading: true, loading: loading),
              ],
            ),
          ),

          // ── Empty ──────────────────────────────
          Empty(:final initial) => EmptyContainer(
            img: initial == true
                ? Assets.svgs.emptyCandidates.path
                : Assets.svgs.emptyBox.path,
            txt: initial == true
                ? allTranslations.text(LocaleKeys.no_talents)
                : allTranslations.text(LocaleKeys.there_is_no_data),
            desc: initial == true
                ? allTranslations.text(LocaleKeys.no_talents_desc)
                : allTranslations.text(LocaleKeys.no_data_desc),
          ),

          // ── Error / fallback ───────────────────
          _ => EmptyContainer(
            img: Assets.svgs.error.path,
            txt: allTranslations.text(LocaleKeys.page_not_found),
            desc: allTranslations.text(LocaleKeys.page_not_found_desc),
          ),
        };
      },
    );
  }
}
