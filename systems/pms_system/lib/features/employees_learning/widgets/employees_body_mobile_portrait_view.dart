import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_events.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_states.dart';
import 'package:pms_system/features/employees_learning/widgets/employee_card.dart';

class EmployeesBodyMobilePortraitView extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController searchController;

  const EmployeesBodyMobilePortraitView({
    super.key,
    required this.scrollController,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EmployeesLearningBloc>();
    return SafeArea(
      child: BlocBuilder<EmployeesLearningBloc, EmployeesLearningState>(
        builder: (context, state) {
          return switch (state) {
            EmployeesLoading() => const ShimmerCardsList(),
            EmployeesLoaded(:final employees, :final isLoadingMore) => Column(
              children: [
                Expanded(
                  child: ListAnimator(
                    customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    controller: scrollController,
                    data: employees
                        .map((emp) => EmployeeCard(employee: emp))
                        .toList(),
                  ),
                ),
                CustomLoading(isTextLoading: true, loading: isLoadingMore),
              ],
            ),
            EmployeesEmpty(:final isInitial) => _HandleEmptyList(
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
  final EmployeesLearningBloc bloc;

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
  final EmployeesLearningBloc bloc;

  const _HandleErrorState({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(const RefreshEmployees());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: context.h * 0.6,
          child: const ErrorContainer(),
        ),
      ),
    );
  }
}
