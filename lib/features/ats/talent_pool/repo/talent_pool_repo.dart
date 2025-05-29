import 'package:eco_system/utility/export.dart';

abstract class TalentPoolRepo {
  static Future<TalentPoolModel> getTalents(SearchEngine data) async {

    return await Network().request(
      ApiNames.talents,
      query: data.query,
      method: ServerMethods.GET,
      model: TalentPoolModel(),
    );
  }
}
