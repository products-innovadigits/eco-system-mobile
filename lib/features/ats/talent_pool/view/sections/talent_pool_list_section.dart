import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/talent_card_widget.dart';
import 'package:eco_system/utility/export.dart';

class TalentPoolListSection extends StatelessWidget {
  const TalentPoolListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalentPoolBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<TalentPoolBloc>();
        final talentsList = bloc.talentsList;
        if (state is Loading) return LoadingShimmerList();
        if (state is Done)
          return Column(
            children: [
              Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      bloc.add(Click(arguments: SearchEngine()));
                    },
                    child: ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: talentsList.length,
                                    controller: bloc.scrollController,
                                    itemBuilder: (context, index) {
                    return TalentCardWidget(
                      onSelectTalent: () =>
                          bloc.add(SelectTalent(arguments: index)),
                      isTalentSelected: bloc.selectedTalentsList.contains(index),
                      isSelectionActive: bloc.activeSelection,
                      talent: talentsList[index],
                    );
                                    },
                                    separatorBuilder: (context, index) => 16.sh,
                                  ),
                  )),
              CustomLoading(isTextLoading: true, loading: state.loading)
            ],
          );
        if (state is Empty || state is Error) {
          return EmptyContainer(
            txt: allTranslations.text("oops"),
            subText: allTranslations.text(state is Error
                ? LocaleKeys.something_went_wrong
                : LocaleKeys.there_is_no_data),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
