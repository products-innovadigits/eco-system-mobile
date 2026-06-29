import 'package:project_management/features/ai_assistant/model/ai_assistant_models.dart';

/// Contract for AI Assistant project search (natural-language query API).
abstract class AiAssistantRepo {
  Future<AiAssistantQueryProjectsResult> queryProjects(
    String query, {
    required String conversationId,
    bool resetContext = false,
    int page = 1,
    int pageSize = 10,
  });

  /// Diagnostics only — GET `/health/deep` on the Project AI base URL. Not used in normal chat flow.
  Future<Map<String, dynamic>?> deepHealth();
}
