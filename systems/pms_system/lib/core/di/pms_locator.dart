import 'package:get_it/get_it.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_reports/domain/cycle_reports_repo.dart';
import 'package:pms_system/features/cycle_review/data/cycle_review_repo_impl.dart';
import 'package:pms_system/features/cycle_review/domain/cycle_review_repo.dart';
import 'package:pms_system/features/cycles/data/cycles_repo_impl.dart';
import 'package:pms_system/features/cycles/domain/cycles_repo.dart';
import 'package:pms_system/features/employee_learning_details/data/employee_learning_details_repo_impl.dart';
import 'package:pms_system/features/employee_learning_details/domain/employee_learning_details_repo.dart';
import 'package:pms_system/features/employees_learning/data/employees_learning_repo_impl.dart';
import 'package:pms_system/features/employees_learning/domain/employees_learning_repo.dart';
import 'package:pms_system/features/employees_performance/data/employees_performance_repo_impl.dart';
import 'package:pms_system/features/employees_performance/domain/employees_performance_repo.dart';

import '../../features/cycle_reports/data/cycle_reports_repo_impl.dart';

final GetIt pmsSl = GetIt.asNewInstance();

void setupPmsLocator() {
  if (!pmsSl.isRegistered<Network>()) {
    pmsSl.registerLazySingleton<Network>(() => Network());
  }

  if (!pmsSl.isRegistered<CyclesRepo>()) {
    pmsSl.registerLazySingleton<CyclesRepo>(
      () => CyclesRepoImpl(network: pmsSl()),
    );
  }

  if (!pmsSl.isRegistered<CycleReviewRepo>()) {
    pmsSl.registerLazySingleton<CycleReviewRepo>(
      () => CycleReviewRepoImpl(network: pmsSl()),
    );
  }

  if (!pmsSl.isRegistered<CycleReportsRepo>()) {
    pmsSl.registerLazySingleton<CycleReportsRepo>(
      () => CycleReportsRepoImpl(network: pmsSl()),
    );
  }

  if (!pmsSl.isRegistered<EmployeeLearningDetailsRepo>()) {
    pmsSl.registerLazySingleton<EmployeeLearningDetailsRepo>(
      () => EmployeeLearningDetailsRepoImpl(network: pmsSl()),
    );
  }

  if (!pmsSl.isRegistered<EmployeesLearningRepo>()) {
    pmsSl.registerLazySingleton<EmployeesLearningRepo>(
      () => EmployeesLearningRepoImpl(network: pmsSl()),
    );
  }

  if (!pmsSl.isRegistered<EmployeesPerformanceRepo>()) {
    pmsSl.registerLazySingleton<EmployeesPerformanceRepo>(
      () => EmployeesPerformanceRepoImpl(network: pmsSl()),
    );
  }
}
