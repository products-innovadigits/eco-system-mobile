import 'package:core_system/core/model/search_engine.dart';
import 'package:project_management/features/latest_request/model/latest_request_models.dart';

abstract class LatestRequestRepo {
  Future<LatestRequestModel> getLatestRequest(SearchEngine data);
}
