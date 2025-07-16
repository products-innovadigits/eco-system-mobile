import 'package:core_package/core/utility/export.dart';
import 'package:eco_system/features/reports/bloc/reports_bloc.dart';
import 'package:eco_system/features/reports/widgets/reports_search_bar.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: allTranslations.text(LocaleKeys.reports) , withBackBtn: false),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ReportsBloc()..add(Click(arguments: SearchEngine())),
          child: BlocBuilder<ReportsBloc, AppState>(
            builder: (context, state) {
              return Column(
                children: [
                  ReportsSearchBar(),
                  Expanded(
                    child: BlocBuilder<ReportsBloc, AppState>(
                      builder: (context, state) {
                        if (state is Loading) {
                          return ListAnimator(
                            customPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
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
                                  controller: context
                                      .read<ReportsBloc>()
                                      .scrollController,
                                  data:  state.cards,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
