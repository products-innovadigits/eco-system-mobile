import '../../../config/api_names.dart';
import '../../../network/network_layer.dart';

abstract class GoalProgressRepo {
  static Future<dynamic> getGoalProgress() async {
    return await Network().request(ApiNames.goalProgress,
         method: ServerMethods.GET);
  }
}
