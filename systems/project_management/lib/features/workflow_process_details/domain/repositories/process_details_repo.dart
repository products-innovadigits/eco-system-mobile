import 'dart:io';

import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';
import 'package:project_management/features/workflow_process_details/model/document_comments_model.dart';
import 'package:project_management/features/workflow_process_details/model/history_model.dart';
import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';
import 'package:project_management/features/workflow_process_details/model/stage_doc_model.dart';
import 'package:project_management/shared/model/default_response_model.dart';

abstract class ProcessDetailsRepo {
  Future<GroupStepsModel> getGroupSteps({
    required int processId,
    required int projectId,
  });

  Future<StageDocResponseModel> getCurrentNextSteps({
    required int processId,
    required int projectId,
    int pageIndex = 1,
    int pageSize = 10,
  });

  Future<DocumentCommentsModel> getDocComments({
    required int documentId,
    int pageIndex = 1,
    int pageSize = 10,
  });

  Future<DefaultResponseModel> addDocComment({
    required int documentId,
    required String text,
  });

  Future<DefaultResponseModel> deleteDocComment({required int documentId});

  Future<DefaultResponseModel> editDocComment({
    required int documentId,
    required int documentDataId,
    required String text,
  });

  Future<HistoryResponseModel> getHistoryData({
    required int processId,
    required int projectId,
  });

  Future<dynamic> addProjectStepComment({
    required int projectId,
    required int projectStepId,
    required int processId,
    required String text,
    File? file,
  });

  Future<dynamic> startProcess({
    required int processId,
    required int projectId,
  });

  /// Moves the process to [nextStepId], or finishes it when [nextStepId] is
  /// null: the last step has no step to move to, so the API is called with a
  /// null next step.
  Future<dynamic> moveToNextStep({
    required int processId,
    required int projectId,
    required int? nextStepId,
  });

  Future<CurrentStepDocumentModel> getCurrentStepDocs({
    required int projectId,
    required int projectStepId,
    required int processId,
  });
}
