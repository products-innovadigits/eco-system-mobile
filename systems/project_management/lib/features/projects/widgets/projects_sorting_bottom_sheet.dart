import 'package:project_management/core/utility/pms_exports.dart';

class ProjectsSortingBottomSheet extends StatelessWidget {
  const ProjectsSortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsSortingBloc, ProjectsSortingState>(
      builder: (context, state) {
        final sortingBloc = context.read<ProjectsSortingBloc>();
        return Stack(
          children: [
            state is SortingLoading
                ? ShimmerCardsList(itemCount: 4, cardHeight: 40, listPadding: 0)
                : ListAnimator(
                    separatorPadding: 16.h,
                    customPadding: EdgeInsets.only(bottom: context.h * 0.1),
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
            SizedBox(height: 80.h),
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
                      SizedBox(width: 8.w),
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
