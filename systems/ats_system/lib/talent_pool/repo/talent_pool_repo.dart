import 'package:core_system/core/model/default_request_model.dart';
import 'package:core_system/core/utility/export.dart';

import '../../shared/ats_exports.dart';
import '../../shared/ats_prototype_data.dart';
import '../model/file_model.dart';

/// Prototype: simulated talent pool — no API.
abstract class TalentPoolRepo {
  static Future<TalentPoolModel> getTalents(SearchEngine data) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return buildPrototypeTalentPoolModel();
  }

  static Future<DefaultRequestModel> assignToJob({
    required List<int> selectedTalentsList,
    required List<int> selectedJobsList,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DefaultRequestModel(
      status: 200,
      message: 'Candidates assigned (prototype).',
    );
  }

  static Future<FileModel> exportFile({
    required List<int> selectedTalentsList,
    required String fileName,
    required bool isExcel,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return FileModel(
      id: 'proto-1',
      name: fileName.isNotEmpty ? fileName : 'export',
      message: isExcel ? 'Excel ready (prototype)' : 'ZIP ready (prototype)',
      url: 'https://example.com/prototype-export',
      createdAt: DateTime.now(),
      fileType: isExcel ? 'xlsx' : 'zip',
      fileSize: 1024,
    );
  }

  static Future<Response> getSortTypes() async {
    await Future.delayed(const Duration(milliseconds: 120));
    return Response(
      requestOptions: RequestOptions(path: ApiNames.sortingList),
      statusCode: 200,
      data: <String, dynamic>{
        'data': <String, dynamic>{
          'recent': 'Most recent',
          'name_asc': 'Name A–Z',
          'compatibility': 'Best match',
        },
      },
    );
  }
}
