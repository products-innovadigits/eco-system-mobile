import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/cycles_bloc.dart';
import 'package:pms_system/features/cycles/bloc/cycles_events.dart';
import 'package:pms_system/features/cycles/bloc/filtration/cycles_filtration_events.dart';
import 'package:pms_system/features/cycles/bloc/filtration/cycles_filtration_state.dart';

class CyclesFiltrationBloc
    extends Bloc<CyclesFiltrationEvent, CyclesFiltrationState> {
  CyclesFiltrationBloc() : super(const CyclesFiltrationInitial()) {
    on<LoadCyclesFilterOptions>(_onLoadFilterOptions);
    on<ApplyCyclesFilters>(_onApplyFilters);
    on<ResetCyclesFilters>(_onResetFilters);
    on<ClearCyclesFilters>(_onClearFilters);
  }

  final List<DropListModel> statusList = [
    DropListModel(name: 'Active'),
    DropListModel(name: 'Completed'),
    DropListModel(name: 'Overdue'),
  ];

  DropListModel? selectedStatus;

  void _onLoadFilterOptions(
    LoadCyclesFilterOptions event,
    Emitter<CyclesFiltrationState> emit,
  ) {
    emit(
      CyclesFiltrationLoaded(
        isFilterApplied: state is CyclesFiltrationLoaded
            ? (state as CyclesFiltrationLoaded).isFilterApplied
            : false,
      ),
    );
  }

  void loadFilterOptions() {
    add(const LoadCyclesFilterOptions());
  }

  void applyFilters({required CyclesBloc cyclesBloc}) {
    if (selectedStatus == null) {
      AppCore.errorToastMessage(
        allTranslations.text(LocaleKeys.please_select_at_least_one_filter),
      );
      return;
    }

    cyclesBloc.add(FilterCycles(status: selectedStatus?.name));
    add(const ApplyCyclesFilters());
    CustomNavigator.pop();
  }

  void _onApplyFilters(
    ApplyCyclesFilters event,
    Emitter<CyclesFiltrationState> emit,
  ) {
    emit(const CyclesFiltrationLoaded(isFilterApplied: true));
  }

  void resetFilters({required CyclesBloc cyclesBloc}) {
    selectedStatus = null;
    add(const ResetCyclesFilters());
    cyclesBloc.add(const RefreshCycles());
    CustomNavigator.pop();
  }

  void _onResetFilters(
    ResetCyclesFilters event,
    Emitter<CyclesFiltrationState> emit,
  ) {
    emit(const CyclesFiltrationLoaded(isFilterApplied: false));
  }

  void clearFilters() {
    selectedStatus = null;
    add(const ClearCyclesFilters());
  }

  void _onClearFilters(
    ClearCyclesFilters event,
    Emitter<CyclesFiltrationState> emit,
  ) {
    emit(const CyclesFiltrationLoaded(isFilterApplied: false));
  }
}
