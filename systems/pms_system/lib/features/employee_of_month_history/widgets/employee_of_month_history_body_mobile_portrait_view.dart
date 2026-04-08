import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_bloc.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_events.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_states.dart';
import 'package:pms_system/features/employee_of_month_history/widgets/employee_of_month_history_card.dart';

class EmployeeOfMonthHistoryBodyMobilePortraitView extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController searchController;

  const EmployeeOfMonthHistoryBodyMobilePortraitView({
    super.key,
    required this.scrollController,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EmployeeOfMonthHistoryBloc>();
    return SafeArea(
      child:
          BlocBuilder<EmployeeOfMonthHistoryBloc, EmployeeOfMonthHistoryState>(
            builder: (context, state) {
              return switch (state) {
                EmployeeOfMonthHistoryInitial() => const ShimmerCardsList(),
                EmployeeOfMonthHistoryLoading() => const ShimmerCardsList(),
                EmployeeOfMonthHistoryLoaded(
                  :final items,
                  :final isLoadingMore,
                ) =>
                  Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                          customPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          controller: scrollController,
                          data: items
                              .map((e) => EmployeeOfMonthHistoryCard(item: e))
                              .toList(),
                        ),
                      ),
                      CustomLoading(
                        isTextLoading: true,
                        loading: isLoadingMore,
                      ),
                    ],
                  ),
                EmployeeOfMonthHistoryEmpty(:final isInitial) =>
                  _HandleEmptyList(
                    initial: isInitial,
                    searchController: searchController,
                    bloc: bloc,
                  ),
                _ => _HandleErrorState(bloc: bloc),
              };
            },
          ),
    );
  }
}

class _HandleEmptyList extends StatelessWidget {
  final bool? initial;
  final TextEditingController searchController;
  final EmployeeOfMonthHistoryBloc bloc;

  const _HandleEmptyList({
    required this.initial,
    required this.searchController,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.6,
      child: EmptyContainer(
        txt: initial == true
            ? null
            : searchController.text.isEmpty
            ? allTranslations.text(LocaleKeys.no_employees_found)
            : '${allTranslations.text(LocaleKeys.no_employees_match)} \'${searchController.text}\'',
      ),
    );
  }
}

class _HandleErrorState extends StatelessWidget {
  final EmployeeOfMonthHistoryBloc bloc;

  const _HandleErrorState({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(const RefreshEmployeeOfMonthHistory());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: context.h * 0.6, child: const ErrorContainer()),
      ),
    );
  }
}
