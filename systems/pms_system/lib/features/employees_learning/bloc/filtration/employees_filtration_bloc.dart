import 'dart:developer';

import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_events.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filtration_events.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filtration_state.dart';
import 'package:pms_system/features/employees_learning/domain/employees_learning_repo.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';

class EmployeesFiltrationBloc
    extends Bloc<EmployeesFiltrationEvent, EmployeesFiltrationState> {
  final EmployeesLearningRepo repo;

  EmployeesFiltrationBloc({required this.repo})
    : super(const EmployeesFiltrationInitial()) {
    on<LoadEmployeesFilterOptions>(_onLoadFilterOptions);
    on<ApplyEmployeesFilters>(_onApplyFilters);
    on<ResetEmployeesFilters>(_onResetFilters);
    on<ClearEmployeesFilters>(_onClearFilters);
  }

  List<DropListModel> teamsList = [];
  List<DropListModel> seniorityList = [];
  DropListModel? selectedTeam;
  DropListModel? selectedSeniority;

  EmployeesFiltersData? _cachedFilterOptions;

  Future<void> _onLoadFilterOptions(
    LoadEmployeesFilterOptions event,
    Emitter<EmployeesFiltrationState> emit,
  ) async {
    try {
      emit(const EmployeesFiltrationLoading());

      EmployeesFiltersModel model = await repo.getFilterOptions();

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
          EmployeesFiltrationLoaded(
            filterOptions: model.data!,
            isFilterApplied: state is EmployeesFiltrationLoaded
                ? (state as EmployeesFiltrationLoaded).isFilterApplied
                : false,
          ),
        );
      } else {
        emit(
          const EmployeesFiltrationFailure(
            message: 'Failed to load filter options',
          ),
        );
      }
    } catch (e) {
      emit(
        const EmployeesFiltrationFailure(
          message: 'Failed to load filter options',
        ),
      );
    }
  }

  void loadFilterOptions() {
    if (teamsList.isEmpty || seniorityList.isEmpty) {
      add(const LoadEmployeesFilterOptions());
    }
  }

  void applyFilters({required EmployeesLearningBloc employeesBloc}) {
    if (selectedTeam == null && selectedSeniority == null) {
      AppCore.errorToastMessage(
        allTranslations.text(LocaleKeys.please_select_at_least_one_filter),
      );
      return;
    }

    employeesBloc.add(
      LoadEmployees(
        searchEngine: SearchEngine(
          query: {
            'teamId': selectedTeam?.id,
            'seniorityLevelId': selectedSeniority?.id,
          },
        ),
      ),
    );
    log("Filter Applied ${selectedTeam?.name} - ${selectedSeniority?.name}");

    add(const ApplyEmployeesFilters());
    CustomNavigator.pop();
  }

  void _onApplyFilters(
    ApplyEmployeesFilters event,
    Emitter<EmployeesFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        EmployeesFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: true,
        ),
      );
    }
  }

  void resetFilters({required EmployeesLearningBloc employeesBloc}) {
    selectedTeam = null;
    selectedSeniority = null;

    add(const ResetEmployeesFilters());
    employeesBloc.add(const RefreshEmployees());
    CustomNavigator.pop();
  }

  void _onResetFilters(
    ResetEmployeesFilters event,
    Emitter<EmployeesFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        EmployeesFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: false,
        ),
      );
    }
  }

  void clearFilters() {
    selectedTeam = null;
    selectedSeniority = null;
    add(const ClearEmployeesFilters());
  }

  void _onClearFilters(
    ClearEmployeesFilters event,
    Emitter<EmployeesFiltrationState> emit,
  ) {
    if (_cachedFilterOptions != null) {
      emit(
        EmployeesFiltrationLoaded(
          filterOptions: _cachedFilterOptions!,
          isFilterApplied: false,
        ),
      );
    }
  }
}
