import 'dart:io';
import 'package:dio/dio.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/workflow_process_details/model/document_comments_model.dart';
import 'package:pms_system/workflow_process_details/model/history_model.dart';
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
        // 'processId': 146,
        'processId': processId,
        // 'projectId': 51,
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

  static Future<dynamic> deleteDocComment({required int documentId}) async {
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

  // History related methods
  static Future<HistoryResponseModel> getHistoryData({
    required int processId,
    required int projectId,
  }) async {
    return await Network().request(
      ApiNames.projectProcessTechnicalLog,
      query: {
        'processId': processId,
        'projectId': projectId,
        'ignoreDeleted': true,
      },
      method: ServerMethods.GET,
      model: HistoryResponseModel(),
    );
  }

  // Project Step Comment methods
  static Future<dynamic> addProjectStepComment({
    required int projectId,
    required int projectStepId,
    required int processId,
    required String text,
    File? file,
  }) async {
    // Use FormData for file upload
    FormData formData = FormData.fromMap({
      // 'projectId': 67,
      'projectId': projectId,
      // 'projectStepId': 152,
      'projectStepId': projectStepId,
      // 'processId': 167,
      'processId': processId,
      'text': text,
      if (file != null)
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
    });

    return await Network().request(
      ApiNames.projectStepComment,
      method: ServerMethods.POST,
      body: formData,
    );
  }

  // Project Process Next Step method
  static Future<dynamic> moveToNextStep({
    required int processId,
    required int projectId,
    required int nextStepId,
  }) async {
    return await Network().request(
      ApiNames.projectProcessNext,
      method: ServerMethods.POST,
      body: {
        // 'id': 146,
        'id': processId,
        // 'projectId': 51,
        'projectId': projectId,
        // 'nextStepId': 170,
        'nextStepId': nextStepId,
      },
    );
  }
}
