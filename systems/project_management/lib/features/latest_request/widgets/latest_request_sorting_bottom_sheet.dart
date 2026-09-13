import 'package:project_management/core/utility/project_management_exports.dart';

class LatestRequestSortingBottomSheet extends StatelessWidget {
  const LatestRequestSortingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestRequestSortingCubit, LatestRequestSortingState>(
      builder: (context, state) {
        final sortingCubit = context.read<LatestRequestSortingCubit>();
        // Options and the current tick come from the state, so a second tap
        // repaints the sheet instead of being swallowed as an equal state.
        final data = state is LatestRequestSortingDataState ? state : null;
        final options = data?.options ?? const <DropListModel>[];
        final selectedKey = data?.selectedOption?.key;
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
                      options.length,
                      (index) => CustomSortTileWidget(
                        title: options[index].name ?? '',
                        isSelected: selectedKey == options[index].key,
                        onSelect: () {
                          sortingCubit.selectSortingOption(options[index]);
                        },
                      ),
                    ),
                  ),
            SizedBox(height: 80.h),
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
                        active: data?.selectedOption != null,
                        onPressed: () {
                          sortingCubit.applySorting();
                          CustomNavigator.pop();
                        },
                      ),
                    ),
                    if (data?.appliedOption != null) ...[
                      SizedBox(width: 8.w),
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
