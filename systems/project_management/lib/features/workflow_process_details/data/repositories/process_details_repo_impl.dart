import 'dart:io';

import 'package:project_management/shared/model/default_response_model.dart';

import '../../../../core/utility/project_management_exports.dart';

/// Prototype: simulated workflow / documents / history — no API.
class ProcessDetailsRepoImpl implements ProcessDetailsRepo {
  final Network network;

  ProcessDetailsRepoImpl({required this.network});

  @override
  Future<GroupStepsModel> getGroupSteps({
    required int processId,
    required int projectId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return GroupStepsModel.fromJson({
      'succeeded': true,
      'data': [
        {
          'groupId': 1,
          'groupName': 'Intake & planning',
          'progress': 75.0,
          'steps': [
            {'id': 10, 'stepName': 'Kickoff', 'status': 2},
            {'id': 11, 'stepName': 'Requirements', 'status': 1},
          ],
        },
        {
          'groupId': 2,
          'groupName': 'Approval',
          'progress': 30.0,
          'steps': [
            {'id': 12, 'stepName': 'Steering committee', 'status': 0},
          ],
        },
      ],
    });
  }

  @override
  Future<StageDocResponseModel> getCurrentNextSteps({
    required int processId,
    required int projectId,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return StageDocResponseModel.fromJson({
      'succeeded': true,
      'data': {
        'workFlowStatus': 'Running',
        'processTitle': 'Budget approval',
        'projectTitle': 'Customer experience platform',
        'projectManager': 'Demo PM',
        'projectBudget': 420000.0,
        'projectStartDate': '2026-01-15',
        'projectEndDate': '2026-11-30',
        'processStageTitle': 'Technical review',
        'stepDocumentId': 9001,
        'currentStep': {
          'id': 11,
          'text': 'Technical review',
          'status': 1,
          'isActiveStep': true,
          'isStartStep': false,
          'isLastStep': false,
        },
        'nextStep': [
          {
            'id': 12,
            'text': 'Steering sign-off',
            'status': 0,
            'isActiveStep': false,
          },
        ],
      },
    });
  }

  @override
  Future<DocumentCommentsModel> getDocComments({
    required int documentId,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 180));
    return DocumentCommentsModel.fromJson({
      'succeeded': true,
      'data': {
        'items': [
          {
            'id': 1,
            'documentDataId': documentId,
            'text': 'Prototype comment — ready for stakeholder review.',
          },
        ],
        'currentPage': 1,
        'pageSize': pageSize,
        'totalPages': 1,
        'nextPage': null,
        'previousPage': null,
        'isLastPage': true,
        'totalCount': 1,
      },
    });
  }

  @override
  Future<DefaultResponseModel> addDocComment({
    required int documentId,
    required String text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DefaultResponseModel(
      succeeded: true,
      data: DefaultResponseData(
        message: 'Comment saved (prototype)',
        messageEn: 'Comment saved (prototype)',
      ),
    );
  }

  @override
  Future<DefaultResponseModel> deleteDocComment({
    required int documentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DefaultResponseModel(
      succeeded: true,
      data: DefaultResponseData(message: 'Deleted', messageEn: 'Deleted'),
    );
  }

  @override
  Future<DefaultResponseModel> editDocComment({
    required int documentId,
    required int documentDataId,
    required String text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DefaultResponseModel(
      succeeded: true,
      data: DefaultResponseData(message: 'Updated', messageEn: 'Updated'),
    );
  }

  @override
  Future<HistoryResponseModel> getHistoryData({
    required int processId,
    required int projectId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return HistoryResponseModel.fromJson({
      'succeeded': true,
      'data': [
        {
          'id': 1,
          'name': 'Kickoff workshop completed',
          'lastChangeTime': '2026-02-10T10:00:00',
          'stepGroup': {'id': 1, 'groupName': 'Intake & planning'},
          'stepComments': <dynamic>[],
          'slicesData': <dynamic>[],
        },
      ],
    });
  }

  @override
  Future<dynamic> addProjectStepComment({
    required int projectId,
    required int projectStepId,
    required int processId,
    required String text,
    File? file,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Response(
      requestOptions: RequestOptions(path: 'stepComment'),
      statusCode: 200,
      data: <String, dynamic>{'succeeded': true},
    );
  }

  @override
  Future<dynamic> startProcess({
    required int processId,
    required int projectId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return Response(
      requestOptions: RequestOptions(path: 'startProcess'),
      statusCode: 200,
      data: <String, dynamic>{'succeeded': true},
    );
  }

  @override
  Future<dynamic> moveToNextStep({
    required int processId,
    required int projectId,
    required int nextStepId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return Response(
      requestOptions: RequestOptions(path: 'nextStep'),
      statusCode: 200,
      data: <String, dynamic>{'succeeded': true},
    );
  }

  @override
  Future<CurrentStepDocumentModel> getCurrentStepDocs({
    required int projectId,
    required int projectStepId,
    required int processId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 180));
    return CurrentStepDocumentModel.fromJson({
      'succeeded': true,
      'data': {
        'totalCount': 1,
        'items': [
          {
            'id': 1,
            'projectId': projectId,
            'processId': processId,
            'stepDocumentId': projectStepId,
            'document': {
              'id': 100,
              'documentTitle': 'Checklist — prototype',
              'isActive': true,
              'symbol': 'CHK',
            },
          },
        ],
      },
    });
  }
}
