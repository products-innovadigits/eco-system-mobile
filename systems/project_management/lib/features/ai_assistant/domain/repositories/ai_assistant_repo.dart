import 'package:project_management/features/ai_assistant/model/ai_assistant_models.dart';

/// Contract for AI Assistant project search (natural-language query API).
abstract class AiAssistantRepo {
  Future<AiAssistantQueryProjectsResult> queryProjects(String query);
}
