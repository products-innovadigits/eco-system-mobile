import 'dart:io';

import 'package:core_system/core/utility/export.dart';
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

  Future<dynamic> moveToNextStep({
    required int processId,
    required int projectId,
    required int nextStepId,
  });

  Future<CurrentStepDocumentModel> getCurrentStepDocs({
    required int projectId,
    required int projectStepId,
    required int processId,
  });
}

class ProcessDetailsRepoImpl implements ProcessDetailsRepo {
  final Network network;

  ProcessDetailsRepoImpl({required this.network});

  @override
  Future<GroupStepsModel> getGroupSteps({
    required int processId,
    required int projectId,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.workflowGroupSteps,
      query: {'processId': processId, 'projectId': projectId},
      method: ServerMethods.GET,
      model: GroupStepsModel(),
    );
    return res as GroupStepsModel;
  }

  @override
  Future<StageDocResponseModel> getCurrentNextSteps({
    required int processId,
    required int projectId,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.currentNextSteps,
      query: {'processId': processId, 'projectId': projectId},
      method: ServerMethods.GET,
      model: StageDocResponseModel(),
    );
    return res as StageDocResponseModel;
  }

  @override
  Future<DocumentCommentsModel> getDocComments({
    required int documentId,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.documentComment,
      query: {
        'documentDataId': documentId,
        'PageIndex': pageIndex,
        'pageSize': pageSize,
      },
      method: ServerMethods.GET,
      model: DocumentCommentsModel(),
    );
    return res as DocumentCommentsModel;
  }

  @override
  Future<DefaultResponseModel> addDocComment({
    required int documentId,
    required String text,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.documentComment,
      method: ServerMethods.POST,
      body: {'documentDataId': documentId, 'text': text},
      model: DefaultResponseModel(),
    );
    return res as DefaultResponseModel;
  }

  @override
  Future<DefaultResponseModel> deleteDocComment({
    required int documentId,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.documentCommentActions(documentId),
      method: ServerMethods.DELETE,
      model: DefaultResponseModel(),
    );
    return res as DefaultResponseModel;
  }

  @override
  Future<DefaultResponseModel> editDocComment({
    required int documentId,
    required int documentDataId,
    required String text,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.documentCommentActions(documentId),
      method: ServerMethods.PUT,
      body: {'documentDataId': documentDataId, 'text': text},
      model: DefaultResponseModel(),
    );
    return res as DefaultResponseModel;
  }

  @override
  Future<HistoryResponseModel> getHistoryData({
    required int processId,
    required int projectId,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.projectProcessTechnicalLog,
      query: {
        'processId': processId,
        'projectId': projectId,
        'ignoreDeleted': true,
      },
      method: ServerMethods.GET,
      model: HistoryResponseModel(),
    );
    return res as HistoryResponseModel;
  }

  @override
  Future<dynamic> addProjectStepComment({
    required int projectId,
    required int projectStepId,
    required int processId,
    required String text,
    File? file,
  }) async {
    FormData formData = FormData.fromMap({
      'projectId': projectId,
      'projectStepId': projectStepId,
      'processId': processId,
      'text': text.trim(),
      if (file != null)
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
    });

    return await network.requestOrThrow(
      ApiNames.projectStepComment,
      method: ServerMethods.POST,
      body: formData,
    );
  }

  @override
  Future<dynamic> startProcess({
    required int processId,
    required int projectId,
  }) async {
    return await network.requestOrThrow(
      ApiNames.projectProcessStart,
      method: ServerMethods.POST,
      body: {'projectId': projectId, 'processId': processId},
    );
  }

  @override
  Future<dynamic> moveToNextStep({
    required int processId,
    required int projectId,
    required int nextStepId,
  }) async {
    return await network.requestOrThrow(
      ApiNames.projectProcessNext,
      method: ServerMethods.POST,
      body: {'id': processId, 'projectId': projectId, 'nextStepId': nextStepId},
    );
  }

  @override
  Future<CurrentStepDocumentModel> getCurrentStepDocs({
    required int projectId,
    required int projectStepId,
    required int processId,
  }) async {
    final res = await network.requestOrThrow(
      ApiNames.currentStepDocs,
      method: ServerMethods.GET,
      query: {
        'projectId': projectId,
        'stepId': projectStepId,
        'processId': processId,
      },
      model: CurrentStepDocumentModel(),
    );
    return res as CurrentStepDocumentModel;
  }
}
