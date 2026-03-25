import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/domain/cycles_repo.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

class CyclesRepoImpl implements CyclesRepo {
  final Network network;

  CyclesRepoImpl({required this.network});

  @override
  Future<CyclesModel> getCycles(SearchEngine data) async {
    final query = data.query as Map<String, dynamic>? ?? <String, dynamic>{};
    final page =
        (query['page'] as int?) ??
        (query['pageIndex'] as int?) ??
        data.nextPageIndex;

    return await network.requestOrThrow(
      ApiNames.appraisalReviewCycles,
      query: <String, dynamic>{'page': page},
      method: ServerMethods.GET,
      systemTypeEnum: ActiveSystemEnum.pms,
      model: CyclesModel(),
    );
  }
}
