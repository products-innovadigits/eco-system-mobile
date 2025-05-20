
import 'package:eco_system/utility/export.dart';

class SortingBottomSheet extends StatelessWidget {
  const SortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TalentPoolBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<TalentPoolBloc>();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.sort),
                24.sh,
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => CustomSortTileWidget(
                        title: bloc.sortingList[index].name ?? '',
                        isSelected: bloc.selectedSorting?.id == index + 1,
                        onSelect: () =>
                            bloc.add(Sort(arguments: bloc.sortingList[index]))),
                    separatorBuilder: (context, index) => 16.sh,
                    itemCount: 6),
                80.sh,
              ],
            ),
            Positioned(
              bottom: 0,
              child: CustomBtn(
                  width: context.w * 0.9,
                  text: allTranslations.text(LocaleKeys.show_all_results),
                  onPressed: () => CustomNavigator.pop()),
            )
          ],
        );
      },
    );
  }
}
