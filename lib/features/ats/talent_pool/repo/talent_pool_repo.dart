import 'package:dio/dio.dart';
import 'package:eco_system/utility/export.dart';

import '../model/file_model.dart';

abstract class TalentPoolRepo {
  static Future<TalentPoolModel> getTalents(SearchEngine data) async {
    return await Network().request(
      ApiNames.talents,
      query: data.query,
      method: ServerMethods.GET,
      model: TalentPoolModel(),
    );
  }

  static Future<DefaultRequestModel> assignToJob(
      {required List<int> selectedTalentsList,
      required List<int> selectedJobsList}) async {
    return await Network().request(
      ApiNames.assignCandidatesToJobs,
      method: ServerMethods.POST,
      body: {"chances": selectedJobsList, "candidates": selectedTalentsList},
      model: DefaultRequestModel(),
    );
  }

  static Future<FileModel> exportFile(
      {required List<int> selectedTalentsList,
      required String fileName,
      required bool isExcel}) async {
    return await Network().request(
      isExcel ? ApiNames.exportExcelFile : ApiNames.exportZipFile,
      method: ServerMethods.POST,
      model: FileModel(),
      body: {"file_name": fileName, "candidate_ids": selectedTalentsList},
    );
  }

  static Future<Response> getSortTypes() async {
    return await Network()
        .request(ApiNames.sortingList, method: ServerMethods.GET);
  }
}
