import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/custom_sort_tile_widget.dart';
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
                        isSelected: bloc.selectedSorting?.key ==
                            bloc.sortingList[index].key,
                        onSelect: () {
                          bloc.add(SelectSorting(
                              arguments: bloc.sortingList.firstWhere(
                                  (element) =>
                                      element.key ==
                                      bloc.sortingList[index].key)));
                        }),
                    separatorBuilder: (context, index) => 16.sh,
                    itemCount: bloc.sortingList.length),
                80.sh,
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: CustomBtn(
                        text:
                            allTranslations.text(LocaleKeys.show_all_results),
                        active: bloc.selectedSorting != null,
                        onPressed: () =>
                            bloc.add(ApplySorting())),
                  ),
                  if (bloc.appliedSorting != null) ...[
                    8.sw,
                    Expanded(
                      child: CustomBtn(
                          text: allTranslations.text(LocaleKeys.reset),
                          color: Styles.WHITE_COLOR,
                          textColor: Styles.PRIMARY_COLOR,
                          borderColor: Styles.PRIMARY_COLOR,
                          onPressed: () =>
                              bloc.add(ResetSorting())),
                    ),
                  ],
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
