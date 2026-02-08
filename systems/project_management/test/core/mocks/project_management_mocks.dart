import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class MockNetwork extends Mock implements Network {}

class MockLatestRequestRepo extends Mock implements LatestRequestRepo {}

class MockProjectCategoriesProgressRepo extends Mock
    implements ProjectCategoriesProgressRepo {}

class MockProjectDetailsRepo extends Mock implements ProjectDetailsRepo {}

class MockProjectReportRepo extends Mock implements ProjectReportRepo {}

class MockProjectsRepo extends Mock implements ProjectsRepo {}

class MockProjectProgressRepo extends Mock implements ProjectProgressRepo {}

class MockProcessDetailsRepo extends Mock implements ProcessDetailsRepo {}
