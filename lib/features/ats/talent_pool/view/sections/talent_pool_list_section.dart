import 'package:eco_system/utility/export.dart';

class TalentPoolListSection extends StatelessWidget {
  const TalentPoolListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalentPoolBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<TalentPoolBloc>();
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: 6,
          itemBuilder: (context, index) {
            return TalentCardWidget(
              onSelectTalent: () => bloc.add(SelectTalent(arguments: index)),
              isTalentSelected: bloc.selectedTalentsList.contains(index),
              isSelectionActive: bloc.activeSelection,
            );
          },
          separatorBuilder: (context, index) => 16.sh,
        );
      },
    );
  }
}
