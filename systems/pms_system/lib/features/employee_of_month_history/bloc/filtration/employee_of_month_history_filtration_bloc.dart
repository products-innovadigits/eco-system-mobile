import 'dart:developer';

import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_bloc.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_events.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_events.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_state.dart';
import 'package:pms_system/features/employee_of_month_history/domain/employee_of_month_history_repo.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';

class EmployeeOfMonthHistoryFiltrationBloc extends Bloc<
    EmployeeOfMonthHistoryFiltrationEvent, EmployeeOfMonthHistoryFiltrationState> {
  final EmployeeOfMonthHistoryRepo repo;

  EmployeeOfMonthHistoryFiltrationBloc({required this.repo})
      : super(const EmployeeOfMonthHistoryFiltrationInitial()) {
    on<LoadEmployeeOfMonthHistoryFilterOptions>(_onLoadFilterOptions);
    on<ApplyEmployeeOfMonthHistoryFilters>(_onApplyFilters);
    on<ResetEmployeeOfMonthHistoryFilters>(_onResetFilters);
    on<ClearEmployeeOfMonthHistoryFilters>(_onClearFilters);
  }

  List<DropListModel> teamsList = [];
  List<DropListModel> seniorityList = [];
  DropListModel? selectedTeam;
  DropListModel? selectedSeniority;

  EmployeesFiltersData? _cachedFilterOptions;

  Future<void> _onLoadFilterOptions(
    LoadEmployeeOfMonthHistoryFilterOptions event,
    Emitter<EmployeeOfMonthHistoryFiltrationState> emit,
  ) async {
    try {
      emit(const EmployeeOfMonthHistoryFiltrationLoading());

      final EmployeesFiltersModel model = await repo.getFilterOptions();

      if (model.succeeded == true && model.data != null) {
        if (model.data!.teams != null) {
          teamsList = model.data!.teams!
              .map((t) => DropListModel(id: t.id, name: t.name ?? ''))
              .toList();
        }

        if (model.data!.seniorityLevels != null) {
          seniorityList = model.data!.seniorityLevels!
              .map((s) => DropListModel(id: s.id, name: s.name ?? ''))
              .toList();
        }

        _cachedFilterOptions = model.data!;
        emit(
          EmployeeOfMonthHistoryFiltrationLoaded(
            filterOptions: model.data!,
            isFilterApplied: state is EmployeeOfMonthHistoryFiltrationLoaded
                ? (state as EmployeeOfMonthHistoryFiltrationLoaded)
                    .isFilterApplied
                : false,
          ),
        );
      } else {
        emit(
          const EmployeeOfMonthHistoryFiltrationFailure(
            message: 'Failed to load filter options',
          ),
        );
      }
    } catch (e) {
      emit(
        const EmployeeOfMonthHistoryFiltrationFailure(
          message: 'Failed to load filter options',
        ),
      );
    }
  }

  void loadFilterOptions() {
    if (teamsList.isEmpty || seniorityList.isEmpty) {
      add(const LoadEmployeeOfMonthHistoryFilterOptions());
    }
  }

  void applyFilters({
    required EmployeeOfMonthHistoryBloc historyBloc,
  }) {
    if (selectedTeam == null && selectedSeniority == null) {
      AppCore.errorToastMessage(
        allTranslations.text(LocaleKeys.please_select_at_least_one_filter),
      );
      return;
    }

    historyBloc.add(
      LoadEmployeeOfMonthHistory(
        searchEngine: SearchEngine(
          query: {
            'teamId': selectedTeam?.id,
            'seniorityLevelId': selectedSeniority?.id,
          },
        ),
      ),
    );
    log(
      'Employee of month history filter applied ${selectedTeam?.name} - ${selectedSeniority?.name}',
    );

    add(const ApplyEmployeeOfMonthHistoryFilters());
    CustomNavigator.pop();
  }

  void _onApplyFilters(
    ApplyEmployeeOfMonthHistoryFilters event,
    Emitter<EmployeeOfMonthHistoryFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        EmployeeOfMonthHistoryFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: true,
        ),
      );
    }
  }

  void resetFilters({required EmployeeOfMonthHistoryBloc historyBloc}) {
    selectedTeam = null;
    selectedSeniority = null;

    add(const ResetEmployeeOfMonthHistoryFilters());
    historyBloc.add(const RefreshEmployeeOfMonthHistory());
    CustomNavigator.pop();
  }

  void _onResetFilters(
    ResetEmployeeOfMonthHistoryFilters event,
    Emitter<EmployeeOfMonthHistoryFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        EmployeeOfMonthHistoryFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: false,
        ),
      );
    }
  }

  void clearFilters() {
    selectedTeam = null;
    selectedSeniority = null;
    add(const ClearEmployeeOfMonthHistoryFilters());
  }

  void _onClearFilters(
    ClearEmployeeOfMonthHistoryFilters event,
    Emitter<EmployeeOfMonthHistoryFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        EmployeeOfMonthHistoryFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: false,
        ),
      );
    }
  }
}
