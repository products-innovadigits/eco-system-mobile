import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/workflow_process_details/model/workflow_process_details_model.dart';

abstract class WorkflowProcessDetailsRepo {
  static Future<WorkflowProcessDetailsModel> getWorkflowProcessDetails({
    required int processId,
    required int projectId,
  }) async {
    return await Network().request(
      ApiNames.workflowProcessDetails,
      query: {'processId': processId, 'projectId': projectId},
      method: ServerMethods.GET,
      model: WorkflowProcessDetailsModel()
    );
  }
}
