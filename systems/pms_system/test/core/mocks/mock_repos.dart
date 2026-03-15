import 'package:mocktail/mocktail.dart';
import 'package:pms_system/features/cycles/domain/cycles_repo.dart';
import 'package:pms_system/features/cycle_review/domain/cycle_review_repo.dart';
import 'package:pms_system/features/cycle_reports/domain/cycle_reports_repo.dart';
import 'package:pms_system/features/employees_learning/domain/employees_learning_repo.dart';
import 'package:pms_system/features/employees_performance/domain/employees_performance_repo.dart';

class MockCyclesRepo extends Mock implements CyclesRepo {}

class MockCycleReviewRepo extends Mock implements CycleReviewRepo {}

class MockCycleReportsRepo extends Mock implements CycleReportsRepo {}

class MockEmployeesLearningRepo extends Mock implements EmployeesLearningRepo {}

class MockEmployeesPerformanceRepo extends Mock
    implements EmployeesPerformanceRepo {}
