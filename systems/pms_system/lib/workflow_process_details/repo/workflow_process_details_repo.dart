import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/workflow_process_details/model/document_comments_model.dart';
import 'package:pms_system/workflow_process_details/model/stage_doc_model.dart';
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
      model: WorkflowProcessDetailsModel(),
    );
  }

  static Future<StageDocResponseModel> getStageDocs({
    required int processId,
    required int projectId,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    return await Network().request(
      ApiNames.stageDocsData,
      query: {
        'processId': processId,
        'projectId': projectId,
        'pageIndex': pageIndex,
        'pageSize': pageSize,
      },
      method: ServerMethods.GET,
      model: StageDocResponseModel(),
    );
  }

  static Future<DocumentCommentsModel> getDocComments({
    required int documentId,
  }) async {
    return await Network().request(
      ApiNames.documentComment,
      query: {'documentDataId': documentId},
      method: ServerMethods.GET,
      model: DocumentCommentsModel(),
    );
  }

  static Future<dynamic> addDocComment({
    required int documentId,
    required String text,
  }) async {
    return await Network().request(
      ApiNames.documentComment,
      method: ServerMethods.POST,
      body: {'documentDataId': documentId, 'text': text},
    );
  }

  static Future<dynamic> deleteDocComment({
    required int documentId,
  }) async {
    return await Network().request(
      ApiNames.documentCommentActions(documentId),
      method: ServerMethods.DELETE,
    );
  }

  static Future<dynamic> editDocComment({
    required int documentId,
    required int documentDataId,
    required String text,
  }) async {
    return await Network().request(
      ApiNames.documentCommentActions(documentId),
      method: ServerMethods.PUT,
      body: {'documentDataId': documentDataId, 'text': text},
    );
  }
}
