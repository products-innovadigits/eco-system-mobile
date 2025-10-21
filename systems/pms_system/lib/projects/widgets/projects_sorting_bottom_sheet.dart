import 'package:pms_system/projects/bloc/projects_sorting_bloc.dart';
import 'package:pms_system/projects/bloc/projects_sorting_events.dart';
import 'package:pms_system/projects/bloc/projects_sorting_states.dart';
import 'package:pms_system/projects/widgets/custom_sort_tile_widget.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectsSortingBottomSheet extends StatelessWidget {
  const ProjectsSortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsSortingBloc, AppState>(
      builder: (context, state) {
        final sortingBloc = context.read<ProjectsSortingBloc>();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: allTranslations.text(LocaleKeys.sort)),
                24.sh,
                state is SortingLoading
                    ? ShimmerCardsList(
                        itemCount: 4,
                        cardHeight: 30,
                        listPadding: 0,
                      )
                    : ListAnimator(
                        separatorPadding: 16.h,
                        data: List.generate(
                          sortingBloc.sortingOptions.length,
                          (index) => CustomSortTileWidget(
                            title: sortingBloc.sortingOptions[index].name ?? '',
                            isSelected:
                                sortingBloc.selectedOption?.key ==
                                sortingBloc.sortingOptions[index].key,
                            onSelect: () {
                              sortingBloc.add(
                                SelectSortingOption(
                                  arguments: sortingBloc.sortingOptions[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                80.sh,
              ],
            ),
            if (state is SortingOptionsLoaded ||
                state is SortingOptionSelected ||
                state is SortingApplied)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomBtn(
                        text: allTranslations.text(LocaleKeys.show_all_results),
                        active: sortingBloc.hasSelectedOption,
                        onPressed: () {
                          sortingBloc.add(ApplySortingOption());
                          CustomNavigator.pop();
                        },
                      ),
                    ),
                    if (sortingBloc.hasAppliedSorting) ...[
                      8.sw,
                      Expanded(
                        child: CustomBtn(
                          text: allTranslations.text(LocaleKeys.reset),
                          color: context.color.surfaceContainer,
                          textColor: context.color.primary,
                          borderColor: context.color.primary,
                          onPressed: () {
                            sortingBloc.add(ResetSortingOption());
                            CustomNavigator.pop();
                          },
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
