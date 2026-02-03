import 'package:project_management/core/utility/pms_exports.dart';

abstract class LatestRequestRepo {
  Future<LatestRequestModel> getLatestRequest(SearchEngine data);
}

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
