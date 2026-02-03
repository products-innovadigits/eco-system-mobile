import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/latest_request/repo/latest_request_repo.dart';
import 'package:project_management/features/project_categories_progress/repo/project_categories_progress_repo.dart';
import 'package:project_management/features/project_details/repo/project_details_repo.dart';
import 'package:project_management/features/project_report/repo/project_report_repo.dart';
import 'package:project_management/features/projects/repo/projects_repo.dart';
import 'package:project_management/features/projects_progress/repo/projects_progress_repo.dart';
import 'package:project_management/features/workflow_process_details/repo/process_details_repo.dart';

class MockLatestRequestRepo extends Mock implements LatestRequestRepo {}

class MockProjectsRepo extends Mock implements ProjectsRepo {}

class MockProjectReportRepo extends Mock implements ProjectReportRepo {}

class MockProjectDetailsRepo extends Mock implements ProjectDetailsRepo {}

class MockProcessDetailsRepo extends Mock implements ProcessDetailsRepo {}

class MockProjectCategoriesProgressRepo extends Mock
    implements ProjectCategoriesProgressRepo {}

class MockProjectProgressRepo extends Mock implements ProjectProgressRepo {}
