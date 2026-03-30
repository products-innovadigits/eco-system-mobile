import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/model/employees_filters_model.dart';
import 'package:pms_system/features/employees_learning/model/employees_learning_model.dart';
import 'package:pms_system/features/employees_learning/model/seniority_levels_model.dart';
import 'package:pms_system/features/employees_learning/model/teams_model.dart';

abstract class EmployeesLearningRepo {
  Future<EmployeesLearningModel> getEmployees(SearchEngine data);
  Future<EmployeesFiltersModel> getFilterOptions();
  Future<SeniorityLevelsModel> getSeniorityLevels();
  Future<TeamsModel> getTeams();
}
