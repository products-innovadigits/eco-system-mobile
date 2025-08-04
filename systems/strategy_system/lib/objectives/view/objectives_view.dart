
import 'package:strategy_system/objectives/widgets/filter/objectives_filter_bottomsheet.dart';

import '../../shared/strategy_exports.dart';

class ObjectivesView extends StatelessWidget {
  const ObjectivesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ObjectivesBloc()..add(Click(arguments: SearchEngine())),
      child: BlocBuilder<ObjectivesBloc, AppState>(
        builder: (context, state) {
          final bloc = context.read<ObjectivesBloc>();
          final objectivesFiltrationBloc = context.read<ObjectivesFiltrationBloc>();
          return Scaffold(
            appBar: CustomAppBar(
              title: allTranslations.text(LocaleKeys.objectives),
              withSearch: true,
              withFilter: true,
              isFiltered: objectivesFiltrationBloc.isFilterApplied,
              // isSorted: bloc.appliedSorting != null,
              withSorting: true,
              withCancelBtn: true,
              onSearching: (value) =>
                  bloc.add(Click(arguments: SearchEngine())),
              // onCanceling: () => bloc.onCancelSearch(),
              searchController: bloc.searchTEC,
              searchHintText: allTranslations.text(LocaleKeys.search_hint),
              onFiltering: () {
                PopUpHelper.showBottomSheet(
                  child: BlocProvider.value(
                      value: bloc, child: ObjectivesFilterBottomSheet()),
                );
              },
              onSorting: () {
                //   PopUpHelper.showBottomSheet(
                //   child: BlocProvider.value(
                //     value: context.read<TalentPoolBloc>(),
                //     child: const SortingBottomSheet(),
                //   ),
                // );
              },
            ),
            body: SafeArea(
              child: BlocBuilder<ObjectivesBloc, AppState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return ListAnimator(
                      customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      data: List.generate(
                        10,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: CustomShimmerContainer(
                            height: 125.h,
                            width: context.w,
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is Done) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListAnimator(
                            customPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            controller: context
                                .read<ObjectivesBloc>()
                                .scrollController,
                            data: state.cards,
                          ),
                        ),
                        CustomLoading(
                          isTextLoading: true,
                          loading: state.loading,
                        ),
                      ],
                    );
                  }
                  if (state is Empty || state is Error) {
                    return EmptyContainer(
                      txt: allTranslations.text("oops"),
                      desc: allTranslations.text(
                        state is Error
                            ? "something_went_wrong"
                            : "there_is_no_data",
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
