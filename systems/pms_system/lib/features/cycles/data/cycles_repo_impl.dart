import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/domain/cycles_repo.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

class CyclesRepoImpl implements CyclesRepo {
  final Network network;

  CyclesRepoImpl({required this.network});

  @override
  Future<CyclesModel> getCycles(SearchEngine data) async {
    final raw = data.query;
    final query = Map<String, dynamic>.from(
      raw is Map<String, dynamic> ? raw : <String, dynamic>{},
    );
    final page =
        (query['page'] as int?) ??
        (query['pageIndex'] as int?) ??
        data.nextPageIndex;
    query['page'] = page;
    query.remove('pageIndex');

    return await network.requestOrThrow(
      ApiNames.appraisalReviewCycles,
      query: query,
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: CyclesModel(),
    );
  }
}
