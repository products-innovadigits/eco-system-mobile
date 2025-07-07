

import '../../shared/strategy_exports.dart';

class ObjectivesView extends StatelessWidget {
  const ObjectivesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: allTranslations.text("objectives"),
      ),
      body: SafeArea(
          child: BlocProvider(
        create: (context) =>
            ObjectivesBloc()..add(Click(arguments: SearchEngine())),
        child: BlocBuilder<ObjectivesBloc, AppState>(
          builder: (context, state) {
            return Column(
              children: [
                ObjectivesSearchBar(),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                //   child: Row(
                //     children: [
                //       Text(
                //         allTranslations.text("all_objectives"),
                //         style: AppTextStyles.w600
                //             .copyWith(fontSize: 16, color: Styles.HEADER),
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(child: BlocBuilder<ObjectivesBloc, AppState>(
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
                                )),
                      );
                    }
                    if (state is Done) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListAnimator(
                              customPadding:
                                  EdgeInsets.symmetric(horizontal: 16.w),
                              controller: context
                                  .read<ObjectivesBloc>()
                                  .scrollController,
                              data: state.cards,
                            ),
                          ),
                          CustomLoading(
                              isTextLoading: true, loading: state.loading)
                        ],
                      );
                    }
                    if (state is Empty || state is Error) {
                      return EmptyContainer(
                        txt: allTranslations.text("oops"),
                        desc: allTranslations.text(state is Error
                            ? "something_went_wrong"
                            : "there_is_no_data"),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ))
              ],
            );
          },
        ),
      )),
    );
  }
}
