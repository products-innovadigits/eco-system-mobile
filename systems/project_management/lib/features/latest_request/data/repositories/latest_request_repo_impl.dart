import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/model/search_engine.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/latest_request/domain/repositories/latest_request_repo.dart';
import 'package:project_management/features/latest_request/model/latest_request_models.dart';

class LatestRequestRepoImpl implements LatestRequestRepo {
  final Network network;

  LatestRequestRepoImpl({required this.network});

  @override
  Future<LatestRequestModel> getLatestRequest(SearchEngine data) async {
    final res = await network.requestOrThrow(
      ApiNames.latestRequest,
      query: data.query,
      method: ServerMethods.GET,
      model: LatestRequestModel(),
    );
    return res as LatestRequestModel;
  }
}
