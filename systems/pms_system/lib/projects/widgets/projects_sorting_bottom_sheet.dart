import 'package:pms_system/projects/widgets/custom_sort_tile_widget.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectsSortingBottomSheet extends StatelessWidget {
  const ProjectsSortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<ProjectsBloc>();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: allTranslations.text(LocaleKeys.sort)),
                24.sh,
                ListAnimator(
                  separatorPadding: 16.h,
                  data: List.generate(
                    bloc.sortingList.length,
                    (index) => CustomSortTileWidget(
                      title: bloc.sortingList[index].name ?? '',
                      isSelected:
                          bloc.selectedSorting?.key ==
                          bloc.sortingList[index].key,
                      onSelect: () {
                        bloc.add(
                          SelectSorting(
                            arguments: bloc.sortingList.firstWhere(
                              (element) =>
                                  element.key == bloc.sortingList[index].key,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
                      text: allTranslations.text(LocaleKeys.show_all_results),
                      active: bloc.selectedSorting != null,
                      onPressed: () => bloc.add(ApplySorting()),
                    ),
                  ),
                  if (bloc.appliedSorting != null) ...[
                    8.sw,
                    Expanded(
                      child: CustomBtn(
                        text: allTranslations.text(LocaleKeys.reset),
                        color: context.color.surfaceContainer,
                        textColor: context.color.primary,
                        borderColor: context.color.primary,
                        onPressed: () => bloc.add(ResetSorting()),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
