import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/latest_request/domain/repositories/latest_request_repo.dart';
import 'package:project_management/features/project_categories_progress/domain/repositories/project_categories_progress_repo.dart';
import 'package:project_management/features/project_details/domain/repositories/project_details_repo.dart';
import 'package:project_management/features/project_report/domain/repositories/project_report_repo.dart';
import 'package:project_management/features/projects/domain/repositories/projects_repo.dart';
import 'package:project_management/features/projects_progress/domain/repositories/projects_progress_repo.dart';
import 'package:project_management/features/workflow_process_details/domain/repositories/process_details_repo.dart';

class MockLatestRequestRepo extends Mock implements LatestRequestRepo {}

class MockProjectsRepo extends Mock implements ProjectsRepo {}

class MockProjectReportRepo extends Mock implements ProjectReportRepo {}

class MockProjectDetailsRepo extends Mock implements ProjectDetailsRepo {}

class MockProcessDetailsRepo extends Mock implements ProcessDetailsRepo {}

class MockProjectCategoriesProgressRepo extends Mock
    implements ProjectCategoriesProgressRepo {}

class MockProjectProgressRepo extends Mock implements ProjectProgressRepo {}
