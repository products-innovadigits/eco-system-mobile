import 'package:project_management/features/project_details/model/project_details_model.dart';

/// Contract for AI Assistant project search (natural-language query API).
abstract class AiAssistantRepo {
  Future<List<ProjectDetailsDataModel>> queryProjects(String query);
}
