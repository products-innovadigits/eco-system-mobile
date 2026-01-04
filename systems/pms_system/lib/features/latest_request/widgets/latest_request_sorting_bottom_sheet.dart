import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/latest_request/bloc/sorting/latest_request_sorting_cubit.dart';
import 'package:pms_system/features/latest_request/bloc/sorting/latest_request_sorting_state.dart';
import 'package:pms_system/features/projects/widgets/projects_sorting/custom_sort_tile_widget.dart';

class LatestRequestSortingBottomSheet extends StatelessWidget {
  const LatestRequestSortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestRequestSortingCubit, LatestRequestSortingState>(
      builder: (context, state) {
        final sortingCubit = context.read<LatestRequestSortingCubit>();
        return Stack(
          children: [
            state is LatestRequestSortingLoading
                ? const ShimmerCardsList(
                    itemCount: 4,
                    cardHeight: 40,
                    listPadding: 0,
                  )
                : ListAnimator(
                    separatorPadding: 16.h,
                    customPadding: EdgeInsets.only(bottom: context.h * 0.1),
                    data: List.generate(
                      sortingCubit.sortingOptions.length,
                      (index) => CustomSortTileWidget(
                        title: sortingCubit.sortingOptions[index].name ?? '',
                        isSelected:
                            sortingCubit.selectedOption?.key ==
                            sortingCubit.sortingOptions[index].key,
                        onSelect: () {
                          sortingCubit.selectSortingOption(
                            sortingCubit.sortingOptions[index],
                          );
                        },
                      ),
                    ),
                  ),
            80.sh,
            if (state is LatestRequestSortingOptionsLoaded ||
                state is LatestRequestSortingOptionSelected ||
                state is LatestRequestSortingApplied)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomBtn(
                        text: allTranslations.text(LocaleKeys.show_all_results),
                        active: sortingCubit.hasSelectedOption,
                        onPressed: () {
                          sortingCubit.applySorting();
                          CustomNavigator.pop();
                        },
                      ),
                    ),
                    if (sortingCubit.hasAppliedSorting) ...[
                      8.sw,
                      Expanded(
                        child: CustomBtn(
                          text: allTranslations.text(LocaleKeys.reset),
                          color: context.color.surfaceContainer,
                          textColor: context.color.primary,
                          borderColor: context.color.primary,
                          onPressed: () {
                            sortingCubit.resetSorting();
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
