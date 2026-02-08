import 'package:project_management/core/utility/project_management_exports.dart';

/// Abstract interface for providing filter parameters to ProjectsBloc.
/// This decouples the bloc from the specific filter implementation.
abstract class ProjectsFilterProvider {
  /// Returns the current filter parameters as a map.
  Map<String, dynamic> getFilterParams();
}

/// Implementation that wraps ProjectsFiltrationBloc to provide filter params.
class ProjectsFiltrationBlocFilterProvider implements ProjectsFilterProvider {
  final ProjectsFiltrationBloc bloc;

  const ProjectsFiltrationBlocFilterProvider(this.bloc);

  @override
  Map<String, dynamic> getFilterParams() {
    final params = <String, dynamic>{};

    if (bloc.selectedStatus != null) {
      params['status'] = bloc.selectedStatus!.name;
    }
    if (bloc.selectedCategory != null) {
      params['projectCategoryId'] = bloc.selectedCategory!.id;
    }
    if (bloc.selectedRisk != null) {
      params['riskLevelId'] = bloc.selectedRisk!.id;
    }
    if (bloc.selectedPriority != null) {
      params['periortyLevelId'] = bloc.selectedPriority!.id;
    }
    if (bloc.pickedStartCtrl.text.isNotEmpty) {
      params['startDate'] = bloc.pickedStartCtrl.text;
    }
    if (bloc.pickedEndCtrl.text.isNotEmpty) {
      params['endDate'] = bloc.pickedEndCtrl.text;
    }

    return params;
  }
}
